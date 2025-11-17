export default async function handler(req, res) {
  // 1. CORS Headers (Strictly needed for some browser setups)
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
  res.setHeader(
    'Access-Control-Allow-Headers',
    'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'
  );

  // 2. Handle the "Pre-flight" check
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // 3. The Echo Response (No AI)
  try {
    return res.status(200).json({ 
      content: [{ text: "CONNECTION SUCCESSFUL. The pipeline is working." }] 
    });
  } catch (error) {
    return res.status(500).json({ error: "Server crashed." });
  }
}
