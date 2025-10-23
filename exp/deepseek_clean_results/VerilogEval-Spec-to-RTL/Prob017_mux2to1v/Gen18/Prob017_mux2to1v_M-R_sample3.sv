module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Mask-based implementation using bitwise operations
    // {100{sel}} creates a 100-bit mask of all 1s when sel=1, all 0s when sel=0
    // {100{~sel}} creates the inverse mask
    assign out = (a & {100{~sel}}) | (b & {100{sel}});

    /* Implementation Notes:
     * - Functionally equivalent to the ternary operator version
     * - May synthesize differently in some technologies
     * - Explicitly shows the masking operation which can be helpful for understanding
     * - Some synthesis tools might optimize this to the same implementation as ternary
     * - Can be useful when you need explicit control over the masking behavior
     */
endmodule