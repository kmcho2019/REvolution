module TopModule(
    input [99:0] a,  // 100-bit input a
    input [99:0] b,  // 100-bit input b
    input sel,      // select signal
    output [99:0] out // 100-bit output
);

    assign out = sel ? b : a;

endmodule