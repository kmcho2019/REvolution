module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    // Carry-lookahead adder implementation
    wire [7:0] b_sel = do_sub ? ~b : b;
    wire cin = do_sub;
    
    wire [7:0] p = a ^ b_sel;
    wire [7:0] g = a & b_sel;
    
    wire [7:0] c;
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    // Continue similar pattern for c[4] to c[7]...
    assign c[4] = g[3] | (p[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    
    assign out = p ^ {c[6:0], cin};
    
    // Tree-structured zero detection
    wire z_lo = ~(out[0] | out[1] | out[2] | out[3]);
    wire z_hi = ~(out[4] | out[5] | out[6] | out[7]);
    assign result_is_zero = z_lo & z_hi;

endmodule