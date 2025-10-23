module TopModule(
    input [99:0] a,  // 100-bit input port
    input [99:0] b,  // 100-bit input port
    input sel,      // 1-bit select signal
    output [99:0] out  // 100-bit output port
);

assign out = (sel == 1'b0) ? a : b;  // Use ternary operator to select input

endmodule