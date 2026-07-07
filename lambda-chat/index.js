const { getHistory, saveHistory } = require('./history');
const { invokeModel } = require('./bedrock');

exports.handler = async (event) => {
  const headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  };

  // Handle CORS preflight
  if (event.httpMethod === 'OPTIONS') {
    return { statusCode: 200, headers, body: '' };
  }

  try {
    const body = JSON.parse(event.body);
    const { message, sessionId } = body;

    if (!message || !sessionId) {
      return {
        statusCode: 400,
        headers,
        body: JSON.stringify({ error: 'message and sessionId are required' }),
      };
    }

    // 1. Fetch conversation history from DynamoDB
    const history = await getHistory(sessionId);

    // 2. Append the new user message
    const updatedHistory = [
      ...history,
      { role: 'user', content: message },
    ];

    // 3. Call Bedrock with full conversation history
    const assistantReply = await invokeModel(updatedHistory);

    // 4. Save updated history (user message + assistant reply) to DynamoDB
    await saveHistory(sessionId, [
      ...updatedHistory,
      { role: 'assistant', content: assistantReply },
    ]);

    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({ reply: assistantReply, sessionId }),
    };
  } catch (error) {
    console.error('Handler error:', error);
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({ error: 'Internal server error' }),
    };
  }
};
