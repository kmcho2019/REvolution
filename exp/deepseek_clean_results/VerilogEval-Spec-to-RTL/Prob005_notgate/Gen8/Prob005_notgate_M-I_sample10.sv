/*
 * TopModule - Simple NOT gate implementation
 * Input:  in  - Single bit input
 * Output: out - Inverted output (NOT in)
 */
module TopModule (
    input  in,
    output out
);
    // Direct continuous assignment for optimal PPA
    assign out = ~in;
endmodule