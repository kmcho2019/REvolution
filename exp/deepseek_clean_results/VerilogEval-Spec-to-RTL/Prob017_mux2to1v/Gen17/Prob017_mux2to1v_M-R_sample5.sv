module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Implement 2:1 mux using explicit bitwise operations
    assign out = (a & {100{~sel}}) | (b & {100{sel}});

    /* Implementation Notes:
     * - This shows an alternative to the ternary operator implementation
     * - The {100{~sel}} creates a 100-bit mask of the inverted select signal
     * - The {100{sel}} creates a 100-bit mask of the select signal
     * - The AND operations mask the inputs, and the OR combines them
     * - Functionally equivalent to the ternary operator version
     * - May synthesize differently in some technologies
     */
endmodule