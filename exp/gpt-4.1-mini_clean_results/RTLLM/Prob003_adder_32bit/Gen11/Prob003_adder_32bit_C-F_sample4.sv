// 4-bit CLA sub-block module: inputs A,B (4 bits), Cin; outputs S(4 bits), Cout, group P,G
module cla_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] S,
    output       Cout,
    output       P_group,
    output       G_group
);
    wire [3:0] P = A ^ B;
    wire [3:0] G = A & B;
    wire [4:0] C;

    assign C[0] = Cin;
    genvar i;
    generate
        for(i=0; i<4; i=i+1) begin : gen_carry
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign S = P ^ C[3:0];
    assign Cout = C[4];

    // Group propagate and generate for the 4-bit block
    assign P_group = &P;                  // P0 & P1 & P2 & P3
    assign G_group = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

// 16-bit CLA module using four 4-bit CLA blocks and hierarchical carry-lookahead
module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [3:0]  P_group, G_group;
    wire [4:0]  C;  // carry signals for 4-bit blocks, C[0]=Cin
    wire [3:0]  cout_4bit; // carry outs from each 4-bit CLA

    assign C[0] = Cin;

    // Instantiate four 4-bit CLA blocks
    cla_4bit cla_blk0 (.A(A[3:0]),    .B(B[3:0]),    .Cin(C[0]), .S(S[3:0]),    .Cout(cout_4bit[0]), .P_group(P_group[0]), .G_group(G_group[0]));
    cla_4bit cla_blk1 (.A(A[7:4]),    .B(B[7:4]),    .Cin(C[1]), .S(S[7:4]),    .Cout(cout_4bit[1]), .P_group(P_group[1]), .G_group(G_group[1]));
    cla_4bit cla_blk2 (.A(A[11:8]),   .B(B[11:8]),   .Cin(C[2]), .S(S[11:8]),   .Cout(cout_4bit[2]), .P_group(P_group[2]), .G_group(G_group[2]));
    cla_4bit cla_blk3 (.A(A[15:12]),  .B(B[15:12]),  .Cin(C[3]), .S(S[15:12]),  .Cout(cout_4bit[3]), .P_group(P_group[3]), .G_group(G_group[3]));

    // Hierarchical carry-lookahead logic for block carries
    // C[i+1] = G_group[i] | (P_group[i] & C[i])
    genvar i;
    generate
        for(i=0; i<4; i=i+1) begin : block_carry_gen
            assign C[i+1] = G_group[i] | (P_group[i] & C[i]);
        end
    endgenerate

    assign Cout = C[4];
endmodule

// Top-level 32-bit adder using two 16-bit CLA blocks with 1-based indexing on ports
module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    // Lower 16 bits: bits 1 to 16
    cla_16bit cla_lower (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    // Upper 16 bits: bits 17 to 32
    cla_16bit cla_upper (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule