module TopModule(
    input [99:0] a,  // 100-bit input a
    input [99:0] b,  // 100-bit input b
    input sel,      // select input
    output [99:0] out  // 100-bit output out
);

    // Use the ternary operator (?:) to implement the multiplexer
    assign out = sel ? b : a;

endmodule