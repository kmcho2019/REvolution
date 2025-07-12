module HalfXor(
    input  a,
    input  b,
    output y
);
    assign y = a ^ b;
endmodule

module TopModule (
    input  [7:0] in,
    output       parity
);
    // First level: XOR input bits in pairs
    wire [3:0] level1;
    HalfXor hx0 (.a(in[0]), .b(in[1]), .y(level1[0]));
    HalfXor hx1 (.a(in[2]), .b(in[3]), .y(level1[1]));
    HalfXor hx2 (.a(in[4]), .b(in[5]), .y(level1[2]));
    HalfXor hx3 (.a(in[6]), .b(in[7]), .y(level1[3]));

    // Second level: XOR outputs of first level in pairs
    wire [1:0] level2;
    HalfXor hx4 (.a(level1[0]), .b(level1[1]), .y(level2[0]));
    HalfXor hx5 (.a(level1[2]), .b(level1[3]), .y(level2[1]));

    // Final level: XOR outputs of second level to get parity
    HalfXor hx6 (.a(level2[0]), .b(level2[1]), .y(parity));
endmodule