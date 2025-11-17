# Command Reference - Vercel Deployment Fix
**Created:** 2025-11-16 11:45 PM
**Purpose:** Complete command reference for 3-phase deployment fix

---

## PHASE 1: Vercel CLI Installation & Setup

### Install Vercel CLI
```bash
# Install globally via npm
npm install -g vercel

# Verify installation
vercel --version
# Expected output: Vercel CLI 33.x.x (or latest)

# Check if already installed
which vercel
# Expected output: /usr/local/bin/vercel (or similar path)
```

### Link Project to Vercel
```bash
# Navigate to project directory
cd /tmp/sme-chat-test

# Link to existing Vercel project
vercel link
# Will prompt:
# - "Set up and deploy?" → Select existing project
# - Choose your Vercel account
# - Choose the project (sme-chat-test or similar)
# Creates .vercel/ directory with project.json

# Verify link
cat .vercel/project.json
# Should show projectId and orgId
```

### Pull Environment Variables
```bash
# Pull env vars from Vercel to local .env.local
vercel env pull .env.local

# Verify env vars pulled
ls -la .env.local
# Should show file exists

# Check contents (without exposing secrets)
wc -l .env.local
# Should show number of env vars

# Verify ANTHROPIC_API_KEY exists (without printing it)
grep -c "ANTHROPIC_API_KEY" .env.local
# Should output: 1
```

### Verification Commands
```bash
# List recent deployments
vercel ls

# Check project info
vercel inspect

# View current env vars (names only)
vercel env ls
```

---

## PHASE 2: Update Model ID

### Git Status Check
```bash
# Check current branch
git branch --show-current
# Expected: main or master

# Check git status
git status
# Should show working tree clean or modified files

# View current remote
git remote -v
# Should show GitHub repo URL
```

### File Editing
```bash
# Read current api/chat.js to verify line 23
sed -n '23p' /tmp/sme-chat-test/api/chat.js
# Expected output: model: 'claude-3-5-sonnet-20240620',

# View context around line 23 (lines 20-28)
sed -n '20,28p' /tmp/sme-chat-test/api/chat.js
# Shows model configuration block
```

### Make the Change
```bash
# Backup current file (safety)
cp /tmp/sme-chat-test/api/chat.js /tmp/sme-chat-test/api/chat.js.backup

# Use sed to replace model ID (in-place)
sed -i '' "s/claude-3-5-sonnet-20240620/claude-sonnet-4-5-20250929/g" /tmp/sme-chat-test/api/chat.js

# Verify the change
sed -n '23p' /tmp/sme-chat-test/api/chat.js
# Expected output: model: 'claude-sonnet-4-5-20250929',

# Show diff of what changed
diff /tmp/sme-chat-test/api/chat.js.backup /tmp/sme-chat-test/api/chat.js
```

### Git Commit
```bash
# Add the changed file
git add api/chat.js

# Verify staged changes
git diff --staged
# Should show model ID change

# Commit with descriptive message
git commit -m "fix: Update to Claude Sonnet 4.5 official API model (claude-sonnet-4-5-20250929)"

# Verify commit
git log -1 --oneline
# Should show the commit message

# View commit details
git show HEAD
# Shows full diff of the commit
```

### Git Push
```bash
# Push to remote (GitHub)
git push origin main

# Verify push succeeded
git status
# Should show "Your branch is up to date with 'origin/main'"

# Check remote commits
git log origin/main -1 --oneline
# Should match local commit
```

---

## PHASE 3: Deploy & Test

### Deploy to Vercel
```bash
# Deploy to production
vercel --prod

# Expected output:
# - Building...
# - Deploying...
# - Production: https://sme-chat-test.vercel.app [copied to clipboard]
# - Deployment ID: dpl_xxxxx

# Capture deployment URL and ID from output
```

### Monitor Deployment
```bash
# Stream logs in real-time (replace <url> with actual URL)
vercel logs --follow https://sme-chat-test.vercel.app

# Or use deployment ID
vercel logs --follow dpl_xxxxx

# View last 100 log lines
vercel logs https://sme-chat-test.vercel.app -n 100

# Filter logs for errors
vercel logs https://sme-chat-test.vercel.app | grep -i error
```

### Test API Endpoint
```bash
# Test with curl (replace URL with actual)
curl -X POST https://sme-chat-test.vercel.app/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "user", "content": "Hello, test message"}
    ]
  }'

# Expected: JSON response with Claude's message (no 404 error)

# Test and pretty-print JSON (if jq installed)
curl -X POST https://sme-chat-test.vercel.app/api/chat \
  -H "Content-Type: application/json" \
  -d '{"messages":[{"role":"user","content":"Hello"}]}' | jq .

# Check for specific errors in response
curl -s -X POST https://sme-chat-test.vercel.app/api/chat \
  -H "Content-Type: application/json" \
  -d '{"messages":[{"role":"user","content":"test"}]}' | grep -i "not_found_error"
# Should return nothing (no error)
```

### Verify Deployment Status
```bash
# Check deployment status
vercel inspect https://sme-chat-test.vercel.app

# List recent deployments
vercel ls

# Check specific deployment details
vercel inspect dpl_xxxxx
```

---

## ROLLBACK COMMANDS (If Needed)

### Rollback Git Changes
```bash
# If Phase 2 fails, revert the commit
git log -2 --oneline  # Find commit hash
git revert <commit-hash>
git push origin main

# Or reset to previous commit (destructive)
git reset --hard HEAD~1
git push origin main --force
```

### Rollback Vercel Deployment
```bash
# List recent deployments
vercel ls

# Promote a previous deployment to production
vercel promote <previous-deployment-url> --prod

# Or via Vercel dashboard:
# Go to Deployments → Find working deployment → Click "Promote to Production"
```

### Restore Backup File
```bash
# Restore from backup (if file edit failed)
cp /tmp/sme-chat-test/api/chat.js.backup /tmp/sme-chat-test/api/chat.js

# Verify restoration
diff /tmp/sme-chat-test/api/chat.js.backup /tmp/sme-chat-test/api/chat.js
# Should show no differences
```

---

## TROUBLESHOOTING COMMANDS

### Vercel CLI Issues
```bash
# Re-authenticate if CLI fails
vercel login

# Check CLI configuration
cat ~/.vercel/config.json

# Clear CLI cache
rm -rf ~/.vercel/cache
```

### Git Issues
```bash
# Check for uncommitted changes
git status

# Discard local changes (if needed)
git checkout -- api/chat.js

# View git log with graph
git log --graph --oneline -5
```

### File Permission Issues
```bash
# Check file permissions
ls -la /tmp/sme-chat-test/api/chat.js

# Fix permissions if needed
chmod 644 /tmp/sme-chat-test/api/chat.js
```

---

## VERIFICATION CHECKLIST

### Phase 1 Success Criteria
- [ ] `vercel --version` returns version number
- [ ] `.vercel/project.json` exists with projectId
- [ ] `.env.local` exists with ANTHROPIC_API_KEY
- [ ] `vercel ls` shows deployments

### Phase 2 Success Criteria
- [ ] `api/chat.js` line 23 shows `claude-sonnet-4-5-20250929`
- [ ] Git diff shows only model ID change
- [ ] Commit created with descriptive message
- [ ] Push succeeded to GitHub

### Phase 3 Success Criteria
- [ ] `vercel --prod` deployment succeeds
- [ ] Logs show no "not_found_error" for model
- [ ] curl test returns valid JSON response
- [ ] Response contains Claude message content

---

## QUICK REFERENCE

### Most Common Commands
```bash
# Navigate to project
cd /tmp/sme-chat-test

# Check git status
git status

# View file line
sed -n '23p' api/chat.js

# Deploy to production
vercel --prod

# Stream logs
vercel logs --follow <url>

# Test API
curl -X POST <url>/api/chat -H "Content-Type: application/json" -d '{"messages":[{"role":"user","content":"test"}]}'
```

### Emergency Rollback
```bash
# Quick rollback: promote previous deployment
vercel ls
vercel promote <previous-url> --prod
```

---

**STATUS:** Ready for execution
**Last Updated:** 2025-11-16 11:45 PM
