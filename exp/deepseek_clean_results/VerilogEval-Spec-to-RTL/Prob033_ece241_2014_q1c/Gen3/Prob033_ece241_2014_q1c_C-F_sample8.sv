module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire carry_out;
    assign {carry_out, s} = a + b;
    
    // Optimized overflow detection:
    // True when input signs match but result sign differs
    assign overflow = (a[7] == b[7]) & (a[7] != s[7]);
endmodule