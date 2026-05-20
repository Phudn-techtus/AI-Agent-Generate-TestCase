---
type: template
phase: 5
skill: output-formatter
title: Google Sheet Export Format (12-column TSV)
purpose: Định nghĩa cấu trúc 12-column TSV output copy-paste ready vào Google Sheet. Gồm schema cột, ví dụ TSV, hướng dẫn paste, và các variation hỗ trợ.
output_path: project/output/{folder_name}/{input_filename}_{YYYYMMDD}.tsv
consumed_by: [end-user / Google Sheet]
---

**Default Output: 12-Column TSV Format (copy-paste ready to Google Sheet)**

### 12 Columns:

```
Code ID | Item Type | Category | Sub-Category | Object | Data Test | Expected Result | Note | Traceability | Status | Priority | Severity
```

| Column           | Source                                             |
| :--------------- | :------------------------------------------------- |
| Code ID          | From Phase 3 (8-column)                            |
| Item Type        | From Phase 3 (8-column)                            |
| Category         | From Phase 3 (8-column)                            |
| Sub-Category     | From Phase 3 (8-column)                            |
| Object           | From Phase 3 (8-column)                            |
| Data Test        | From Phase 3 (8-column)                            |
| Expected Result  | From Phase 3 (8-column)                            |
| Note             | From Phase 3 (8-column)                            |
| **Traceability** | Mapped from Phase 1 AC/EC (NEW)                    |
| **Status**       | Auto-set: "Ready for Test"                         |
| **Priority**     | Inferred from AC/EC Severity or user input         |
| **Severity**     | From AC/EC Severity (Critical/Major/Minor/Trivial) |

### Example TSV Output (copy-paste ready):

```tsv
Code ID	Item Type	Category	Sub-Category	Object	Data Test	Expected Result	Note	Traceability (AC/EC)	Status	Priority	Severity
TC_DMR_001	CID 6000 - URL 1:1	UI & Form Display	Happy Path	Verify that DM Registration form displays all required fields when page loads -> All fields visible	Chrome (Mac), Edge (Windows), Safari (Mac)	All fields visible	Visual verification	AC-DM-UI-01	Ready for Test	High	Critical
TC_DMR_003	CID 6000 - URL 1:1	CID Input & Validation	Happy Path	Verify that form accepts valid CID input -> CID field accepts value	Valid CID: 12345678	CID field accepts value	RULE-01	AC-DM-FUNC-01	Ready for Test	High	Critical
TC_DMR_018	CID 6000 - URL 1:1	Access Control & Permission	Negative - Unauthorized	Verify that non-admin user is blocked from DM Registration form -> HTTP 403 Forbidden	User Role: Regular User	HTTP 403 Forbidden	RULE-02	AC-DM-SEC-02	Ready for Test	High	Critical
```

### Instructions for Copy-Paste to Google Sheet:

1. Copy entire TSV table (from headers to last row)
2. Create new GG Sheet
3. Edit → Paste special → Paste values only (Cmd+Shift+V / Ctrl+Shift+V)
4. (Optional) Format header row, freeze rows, add filters

### Optional Reference Sheets (add if requested):

1. **AC/EC Reference Sheet:** Lists all AC/EC with related TCs
2. **Traceability Matrix Sheet:** AC/EC ↔ TC mapping for coverage verification

### Supported Variations:

- **Minimal (8 columns):** Without Traceability, Status, Priority, Severity
- **With Environment:** Add column for Test Environment (Web/Mobile/API)
- **With Automation Status:** Add column for Automation Tag (🤖 Auto-ready / 👤 Manual-only)
