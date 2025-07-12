module TopModule (
    input  wire in,   // Single-bit input signal
    output wire out   // Single-bit output: logical negation of 'in'
);
    // Combinational logic: output is the bitwise NOT of input
    assign out = ~in;
endmodule