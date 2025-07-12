module TopModule(
    input [2:0] a, // 3-bit input
    output [15:0] q  // 16-bit output
);

assign q = (a * 16'd4660) + 16'd128;

endmodule