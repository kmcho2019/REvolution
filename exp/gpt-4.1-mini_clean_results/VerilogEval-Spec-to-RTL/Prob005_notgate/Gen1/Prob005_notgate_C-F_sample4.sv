module TopModule (
    input  wire in,   // One-bit input signal
    output wire out   // One-bit output, NOT of input
);
    // Output 'out' is the logical negation of input 'in'
    assign out = ~in;
endmodule