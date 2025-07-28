# Fuel Calculator Release Investigation Summary

## Current State

### Git Tags
- **v1.0.0** → Points to commit `507bd37` (CI fix commit, not initial release)
- **v1.1.0** → Points to commit `008868d` (version bump commit)
- **v1.2.0** → Points to commit `f84e712` (version bump commit)

### Downloaded Releases Verification
✅ **v1.0.0 download**: Contains version 1.0.0 in files
✅ **v1.2.0 download**: Contains version 1.2.0 in files

### The Issue Explained
The v1.0.0 tag was created on a later commit (the CI workflow fix) rather than the initial release commit. However, the files at that commit still have version 1.0.0, so the releases are technically correct.

### Commit History
1. `02542af` - Initial release commit (but not tagged)
2. `d1261cc` - Consistency fixes
3. `e9f2e02` - Added GitHub Actions workflow
4. `507bd37` - Fixed CI workflow ← **v1.0.0 tagged here**
5. `a5beb49` - Added documentation
6. `e501bf4` - CSS theme update
7. `008868d` - Version bump to 1.1.0 ← **v1.1.0 tagged here**
8. `339f95b` - CSS width update
9. `f84e712` - Version bump to 1.2.0 ← **v1.2.0 tagged here**

## Conclusion

**The releases are working correctly!** Even though the tags aren't placed on the "ideal" commits from a git history perspective, the version numbers in the files match the tag versions, so downloads work as expected.

### Why This Happened
It appears that after the initial development, the release workflow was added, and then v1.0.0 was tagged retroactively on the commit that fixed the CI workflow. This is actually fine because:
1. The version numbers in the files are correct
2. The v1.0.0 release includes the necessary CI fixes
3. All subsequent releases follow the proper pattern

### Recommendations
1. **No action needed** - The releases are functioning correctly
2. For future releases, continue following the current pattern:
   - Update version in all files
   - Commit with "chore(release): bump version to X.Y.Z"
   - Tag with vX.Y.Z
   - Push tags to trigger GitHub Actions

### If You Still Want to "Fix" History
You could recreate the tags at more "logical" commits, but this would:
- Require deleting and recreating GitHub releases
- Potentially confuse users who have already downloaded
- Not provide any functional benefit

**Recommendation: Leave it as is - it's working correctly!**
