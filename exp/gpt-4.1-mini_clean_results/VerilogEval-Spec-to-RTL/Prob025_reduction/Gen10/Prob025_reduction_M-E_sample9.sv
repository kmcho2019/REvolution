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
    wire [3:0] stage1;
    wire [1:0] stage2;
    wire       stage3;

    // Stage 1: XOR input bits in pairs using HalfXor modules
    HalfXor hx0(.a(in[0]), .b(in[1]), .y(stage1[0]));
    HalfXor hx1(.a(in[2]), .b(in[3]), .y(stage1[1]));
    HalfXor hx2(.a(in[4]), .b(in[5]), .y(stage1[2]));
    HalfXor hx3(.a(in[6]), .b(in[7]), .y(stage1[3]));

    // Stage 2: XOR pairs of stage 1 results
    HalfXor hx4(.a(stage1[0]), .b(stage1[1]), .y(stage2[0]));
    HalfXor hx5(.a(stage1[2]), .b(stage1[3]), .y(stage2[1]));

    // Stage 3: XOR final pair to get parity
    HalfXor hx6(.a(stage2[0]), .b(stage2[1]), .y(stage3));

    // Output the even parity bit
    assign parity = stage3;
endmodule