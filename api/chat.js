import Anthropic from '@anthropic-ai/sdk';

const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
});

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const { messages } = req.body;

    // This pulls the text safely from Vercel Settings
    const systemPrompt = process.env.SYSTEM_PROMPT || "You are a helpful assistant.";
// --- DEBUG LOGGING ---
    const promptCheck = process.env.SYSTEM_PROMPT;
    console.log("DEBUG: System Prompt Length =", promptCheck ? promptCheck.length : "NOT FOUND");
    console.log("DEBUG: First 50 chars =", promptCheck ? promptCheck.substring(0, 50) : "N/A");
    // ---------------------
    const response = await anthropic.messages.create({
    model: 'claude-3-haiku-20240307',
      max_tokens: 1024,
      temperature: 0.15,
      system: systemPrompt,
      messages: messages,
    });

    return res.status(200).json(response);

  } catch (error) {
    console.error("API Error:", error);
    return res.status(500).json({ error: error.message });
  }
}
