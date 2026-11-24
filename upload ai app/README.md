# YojanaSaathi AI
*The Right Scheme. The Right Guidance. For Everyone.* An independent (non-government) scheme discovery assistant.

## Run locally
**Easiest:** Windows → double-click `start.bat`. Mac/Linux → `bash start.sh`. It installs everything, starts the server and opens http://localhost:8000.

Manual:
```bash
cd backend && python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp ../.env.example .env        # add OPENAI_API_KEY (optional) and ADMIN_KEY
uvicorn main:app --reload      # open http://localhost:8000
```
The backend serves the frontend (`frontend/index.html`), so one process is enough. Without `OPENAI_API_KEY` the app runs in **demo mode**: chat and PDF analysis answer straight from the scheme records. Docs: http://localhost:8000/docs

## Architecture
- `backend/main.py`: FastAPI + Pydantic. Retrieval (keyword/token scoring) feeds only matching scheme records to the LLM as CONTEXT; system prompt forbids invention and treats user/document text as data. Rule-based eligibility engine, checklist, PDF/TXT analysis (pypdf, 5 MB cap, magic-byte check), per-IP rate limits, admin routes behind `X-Admin-Key`.
- `backend/schemes.json`: structured records. **All five are starter data with `verification_status: unverified`.** Verify each on its official site, then use Admin → "Mark verified" (stamps today's date).
- `frontend/index.html`: SPA (Tailwind CDN, hash routing). Profile, saved schemes, checklists and chats live in the browser's localStorage (privacy-first).

## API
| Method | Path | Purpose |
|---|---|---|
| GET | /api/health | status, `ai_enabled` |
| GET | /api/schemes?q&state&category&beneficiary&level | search/filter |
| GET | /api/schemes/{id} | details |
| POST | /api/recommend | profile → ranked schemes with reasons |
| POST | /api/eligibility | `{scheme_id, profile}` → ok / ask / no / missing |
| POST | /api/checklist | personalised document list |
| POST | /api/chat | `{messages, lang: en\|hi, scheme_id?}` → answer + sources |
| POST | /api/upload | multipart PDF/TXT → summary + extracted sections |
| GET/POST/PUT/DELETE | /api/admin/schemes[/{id}] | CRUD (admin key) |
| POST | /api/admin/schemes/{id}/verify | mark verified today |
| GET | /api/admin/stats | usage counts |

## Deploy
- **Backend (Render/Railway):** root `backend`, build `pip install -r requirements.txt`, start `uvicorn main:app --host 0.0.0.0 --port $PORT`; set env vars from `.env.example`. Note: free tiers have ephemeral disks, so admin edits to `schemes.json` reset on redeploy; move the store to Postgres/Supabase for persistence.
- **Frontend (Vercel, optional split):** the app is same-origin by default. To host it separately, deploy `frontend/` and set `const api` base URL to your backend URL and `CORS_ORIGINS` accordingly.

## 3-minute demo script
1. Home: state the mission and the "not a government site" disclaimer.
2. Find schemes: Bihar · 18–25 · Student · ₹1–2.5 lakh · 12th · OBC → NSP and PM YASASVI rank first with reasons.
3. Open PM YASASVI → Eligibility tab: matched / needs-confirmation / missing, with the "not official" notice.
4. Click **Explain in Hindi** → assistant answers in Hindi with the official link.
5. Documents tab: tick items (caste certificate appears as required for OBC); show the privacy note.
6. Roadmap tab → **Official portal ↗**.
7. Document AI: upload a public scheme PDF → summary, eligibility, steps with page refs.
8. Admin (`#/admin`): mark a scheme verified; show the date appear on its page.

## Not included / next steps
User accounts + Postgres, embeddings/pgvector retrieval (swap `retrieve()`), OCR for scanned PDFs, more state schemes.
