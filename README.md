# 🌅 GMIC — Seismic Testnet

Community GM app for Seismic Testnet. Say GMIC every day, build streaks, earn points, climb the leaderboard.

---

## 🔗 Chain Info

| Property | Value |
|----------|-------|
| Network  | Seismic Testnet |
| Chain ID | 5124 |
| RPC      | https://gcp-1.seismictest.net/rpc |
| Explorer | https://seismic-testnet.socialscan.io |
| Faucet   | https://faucet.seismictest.net |

---

## 🚀 Deployment Steps

### Step 1 — Get Testnet ETH
Visit https://faucet.seismictest.net and request test ETH for your wallet.

### Step 2 — Deploy the Smart Contract

**Option A: Remix IDE (Easiest)**
1. Go to https://remix.ethereum.org
2. Create a new file `GMIC.sol` and paste the contract from `contract/GMIC.sol`
3. Compile with Solidity 0.8.20
4. In Deploy tab:
   - Environment: "Injected Provider" (connects your Rabby wallet)
   - Make sure Rabby is on Seismic Testnet (Chain ID 5124)
   - Click Deploy
5. Copy the deployed contract address

**Option B: Hardhat / Foundry**
```bash
# Add Seismic Testnet to your config:
# chainId: 5124
# rpc: https://gcp-1.seismictest.net/rpc
forge create contract/GMIC.sol:GMICSeismic \
  --rpc-url https://gcp-1.seismictest.net/rpc \
  --private-key YOUR_PRIVATE_KEY
```

### Step 3 — Set Contract Address in Frontend

After deploying, open your browser console on the GMIC site and run:
```js
setContractAddress("0xYOUR_DEPLOYED_CONTRACT_ADDRESS")
```
This saves it to localStorage and reloads the page.

**Or** edit `frontend/index.html` and replace the `CONTRACT_ADDRESS` line directly.

### Step 4 — Host the Frontend

**Option A: GitHub Pages**
```bash
git init && git add . && git commit -m "GMIC launch"
git push origin main
# Enable Pages in repo settings → deploy from /frontend
```

**Option B: Vercel / Netlify**
- Drag the `frontend/` folder to https://app.netlify.com/drop

**Option C: Local**
```bash
cd frontend && npx serve .
# Visit http://localhost:3000
```

---

## 🎮 Features

- **TAP TO GMIC** — One GMIC per day per wallet (enforced on-chain)
- **GMIC to a Fren** — Send GMIC to a specific EVM address
- **Streak System** — Day 1: 1pt, Day 2: 2pts, Day 3: 4pts... doubles each day (max 1024)
- **Live Leaderboard** — Top 20 by points, updates every 30s
- **Share on X** — Auto-generated tweet with your streak & points
- **Wallet Connect** — Works with Rabby, MetaMask, and all EVM wallets
- **Auto chain-add** — Automatically adds Seismic Testnet to wallet

---

## 📊 Point Streak Table

| Day | Points |
|-----|--------|
| 1   | 1      |
| 2   | 2      |
| 3   | 4      |
| 4   | 8      |
| 5   | 16     |
| 7   | 64     |
| 10  | 512    |
| 11+ | 1024   |

---

## 🛠 Tech Stack

- **Smart Contract**: Solidity 0.8.20 (EVM-compatible, works on Seismic)
- **Frontend**: Vanilla HTML/CSS/JS (zero dependencies, fast)
- **Web3**: ethers.js v6
- **Fonts**: Syne + Space Mono

---

## 📁 File Structure

```
gmic-seismic/
├── contract/
│   └── GMIC.sol          ← Deploy this on Seismic Testnet
├── frontend/
│   └── index.html        ← Your full website (single file)
│   src/
│   └── abi/gmic.js       ← ABI reference (already embedded in HTML)
└── README.md
```
