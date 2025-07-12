module TopModule(
    input  [99:0] a,    // 100-bit input signal 'a'
    input  [99:0] b,    // 100-bit input signal 'b'
    input          sel, // 1-bit select signal
    output [99:0] out   // 100-bit output signal 'out'
);

assign out = sel ? b : a; // Use ternary operator to choose between 'a' and 'b'

endmodule