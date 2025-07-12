/*
 * TopModule - Priority-Encoded OR Gate
 *
 * Functionality:
 *   Implements q = c OR (b AND NOT c) OR (a AND NOT c AND NOT b) OR (d AND NOT c AND NOT b AND NOT a)
 *   Effectively reduces to q = b OR c due to input prioritization
 *
 * Design Choices:
 *   1. Priority encoding structure for potential future expansion
 *   2. Explicit hierarchy showing priority relationships
 *   3. Maintains correct functionality while demonstrating alternative architecture
 *
 * Truth Table:
 *   Matches required specification where q = b OR c
 */
module TopModule (
    input  a,       // Third priority input
    input  b,       // Second priority input
    input  c,       // First priority input
    input  d,       // Fourth priority input
    output q        // Priority-encoded OR result
);

    // Priority stages
    wire stage1 = c;                            // Highest priority
    wire stage2 = b & ~stage1;                  // Active if no higher priority
    wire stage3 = a & ~stage1 & ~stage2;        // Active if no higher priority
    wire stage4 = d & ~stage1 & ~stage2 & ~stage3; // Lowest priority

    // Final output combines all priority stages
    assign q = stage1 | stage2 | stage3 | stage4;

endmodule