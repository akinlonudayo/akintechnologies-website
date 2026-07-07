const {
  BedrockRuntimeClient,
  InvokeModelCommand,
} = require('@aws-sdk/client-bedrock-runtime');

const client = new BedrockRuntimeClient({
  region: process.env.AWS_REGION || 'us-east-1',
});

// Claude 3 Sonnet on Bedrock - good balance of speed and intelligence
const MODEL_ID = 'anthropic.claude-3-sonnet-20240229-v1:0';

const SYSTEM_PROMPT = `You are a helpful AI assistant powered by AWS Bedrock. 
You are concise, friendly, and clear in your responses. 
If you don't know something, say so honestly.`;

/**
 * Invokes the Claude model on Amazon Bedrock
 * @param {Array} messages - Array of { role: 'user'|'assistant', content: string }
 * @returns {string} - The assistant's reply
 */
exports.invokeModel = async (messages) => {
  const payload = {
    anthropic_version: 'bedrock-2023-05-31',
    max_tokens: 1024,
    system: SYSTEM_PROMPT,
    messages: messages.map((m) => ({
      role: m.role,
      content: m.content,
    })),
  };

  const command = new InvokeModelCommand({
    modelId: MODEL_ID,
    contentType: 'application/json',
    accept: 'application/json',
    body: JSON.stringify(payload),
  });

  const response = await client.send(command);
  const responseBody = JSON.parse(Buffer.from(response.body).toString('utf-8'));

  return responseBody.content[0].text;
};
