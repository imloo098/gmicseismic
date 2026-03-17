// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GMICSeismic {
    // ─── Events ───────────────────────────────────────────────────────────────
    event GMICSaid(address indexed sender, address indexed recipient, uint256 points, uint256 streak, uint256 timestamp);

    // ─── State ────────────────────────────────────────────────────────────────
    struct UserData {
        uint256 totalGMICs;       // total GMICs sent
        uint256 gmicsReceived;    // total GMICs received
        uint256 points;           // total points accumulated
        uint256 streak;           // current streak (consecutive days)
        uint256 lastGMICDay;      // day number of last GMIC (block.timestamp / 86400)
        bool exists;
    }

    mapping(address => UserData) public users;
    address[] public userList;

    uint256 public globalGMICCount;

    // ─── Helpers ──────────────────────────────────────────────────────────────
    function _today() internal view returns (uint256) {
        return block.timestamp / 86400;
    }

    function _streakPoints(uint256 streak) internal pure returns (uint256) {
        // Day 1: 1pt, Day 2: 2pts, Day 3: 4pts, Day 4: 8pts ... doubles each day
        if (streak == 0) return 1;
        uint256 pts = 1;
        for (uint256 i = 1; i < streak; i++) {
            pts = pts * 2;
            if (pts > 1024) { pts = 1024; break; } // cap at 1024
        }
        return pts;
    }

    // ─── Core ─────────────────────────────────────────────────────────────────
    function sayGMIC(address recipient) external {
        address sender = msg.sender;
        require(sender != recipient, "Cannot GMIC yourself");

        UserData storage u = users[sender];
        uint256 today = _today();

        // Register new user
        if (!u.exists) {
            u.exists = true;
            userList.push(sender);
        }

        // Streak logic
        if (u.lastGMICDay == 0) {
            // first ever GMIC
            u.streak = 1;
        } else if (today == u.lastGMICDay + 1) {
            // consecutive day
            u.streak += 1;
        } else if (today > u.lastGMICDay + 1) {
            // streak broken
            u.streak = 1;
        } else {
            // same day - no extra streak but still counts
        }

        u.lastGMICDay = today;
        u.totalGMICs += 1;

        uint256 pts = _streakPoints(u.streak);
        u.points += pts;

        // Update global
        globalGMICCount += 1;

        // Update recipient
        if (!users[recipient].exists) {
            users[recipient].exists = true;
            userList.push(recipient);
        }
        users[recipient].gmicsReceived += 1;

        emit GMICSaid(sender, recipient, pts, u.streak, block.timestamp);
    }

    // Random GMIC (no specific recipient)
    function sayGMICRandom() external {
        this.sayGMIC(address(0x000000000000000000000000000000000000dEaD));
    }

    // ─── Views ────────────────────────────────────────────────────────────────
    function getUser(address user) external view returns (
        uint256 totalGMICs,
        uint256 gmicsReceived,
        uint256 points,
        uint256 streak,
        uint256 lastGMICDay
    ) {
        UserData storage u = users[user];
        return (u.totalGMICs, u.gmicsReceived, u.points, u.streak, u.lastGMICDay);
    }

    function canGMICToday(address user) external view returns (bool) {
        return users[user].lastGMICDay < _today();
    }

    function getLeaderboard(uint256 limit) external view returns (
        address[] memory addrs,
        uint256[] memory pts
    ) {
        uint256 len = userList.length;
        if (limit > len) limit = len;

        // Simple selection sort for top N (fine for small arrays)
        address[] memory tempAddrs = new address[](len);
        uint256[] memory tempPts = new uint256[](len);
        for (uint256 i = 0; i < len; i++) {
            tempAddrs[i] = userList[i];
            tempPts[i] = users[userList[i]].points;
        }

        // Sort descending
        for (uint256 i = 0; i < len; i++) {
            for (uint256 j = i + 1; j < len; j++) {
                if (tempPts[j] > tempPts[i]) {
                    (tempPts[i], tempPts[j]) = (tempPts[j], tempPts[i]);
                    (tempAddrs[i], tempAddrs[j]) = (tempAddrs[j], tempAddrs[i]);
                }
            }
        }

        addrs = new address[](limit);
        pts = new uint256[](limit);
        for (uint256 i = 0; i < limit; i++) {
            addrs[i] = tempAddrs[i];
            pts[i] = tempPts[i];
        }
    }

    function totalUsers() external view returns (uint256) {
        return userList.length;
    }
}
