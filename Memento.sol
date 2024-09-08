// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Memento {
    struct Proposal {
        string description;
        uint256 startTime;
        uint256 endTime;
        uint256[] options;
        bool executed;
    }

    struct Snapshot {
        uint256 burnRate;
        uint256 rewardAmount;
        uint256 proposalCount;
        mapping(uint256 => Proposal) proposals;
    }

    Snapshot[] public snapshots;

    function saveSnapshot(
        uint256 _burnRate,
        uint256 _rewardAmount,
        uint256 _proposalCount,
        mapping(uint256 => Proposal) storage _proposals
    ) external {
        Snapshot storage snapshot = snapshots.push();
        snapshot.burnRate = _burnRate;
        snapshot.rewardAmount = _rewardAmount;
        snapshot.proposalCount = _proposalCount;

        for (uint256 i = 0; i < _proposalCount; i++) {
            snapshot.proposals[i] = _proposals[i];
        }
    }

    function restoreSnapshot(uint256 index, mapping(uint256 => Proposal) storage _proposals) external {
        Snapshot storage snapshot = snapshots[index];
        for (uint256 i = 0; i < snapshot.proposalCount; i++) {
            _proposals[i] = snapshot.proposals[i];
        }
    }
}

