const {
  DynamoDBClient,
  GetItemCommand,
  PutItemCommand,
} = require('@aws-sdk/client-dynamodb');
const { marshall, unmarshall } = require('@aws-sdk/util-dynamodb');

const client = new DynamoDBClient({
  region: process.env.AWS_REGION || 'us-east-1',
});

const TABLE_NAME = process.env.DYNAMODB_TABLE || 'ai-chat-history';

// Keep last 20 messages to stay within Bedrock context limits
const MAX_HISTORY = 20;

/**
 * Fetches conversation history for a session
 * @param {string} sessionId
 * @returns {Array} - Array of { role, content } message objects
 */
exports.getHistory = async (sessionId) => {
  try {
    const command = new GetItemCommand({
      TableName: TABLE_NAME,
      Key: marshall({ sessionId }),
    });

    const response = await client.send(command);

    if (!response.Item) return [];

    const item = unmarshall(response.Item);
    return item.messages || [];
  } catch (error) {
    console.error('DynamoDB getHistory error:', error);
    return [];
  }
};

/**
 * Saves updated conversation history for a session
 * @param {string} sessionId
 * @param {Array} messages - Full updated message array
 */
exports.saveHistory = async (sessionId, messages) => {
  try {
    // Trim to last MAX_HISTORY messages to avoid item size limits
    const trimmed = messages.slice(-MAX_HISTORY);

    // TTL: auto-expire sessions after 24 hours
    const ttl = Math.floor(Date.now() / 1000) + 60 * 60 * 24;

    const command = new PutItemCommand({
      TableName: TABLE_NAME,
      Item: marshall({
        sessionId,
        messages: trimmed,
        updatedAt: new Date().toISOString(),
        ttl,
      }),
    });

    await client.send(command);
  } catch (error) {
    console.error('DynamoDB saveHistory error:', error);
    throw error;
  }
};
