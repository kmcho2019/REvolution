// 8-bit Ripple-Carry Adder
module rca_8bit(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);
    wire [7:1] C;

    assign S[1] = A[1] ^ B[1] ^ C_in;
    assign C[1] = (A[1] & B[1]) | (A[1] & C_in) | (B[1] & C_in);
    for (genvar i = 2; i <= 7; i++) begin
        assign S[i] = A[i] ^ B[i] ^ C[i-1];
        assign C[i] = (A[i] & B[i]) | (A[i] & C[i-1]) | (B[i] & C[i-1]);
    end
    assign S[8] = A[8] ^ B[8] ^ C[7];
    assign C_out = (A[8] & B[8]) | (A[8] & C[7]) | (B[8] & C[7]);
endmodule

// 8-bit Segment Carry-Lookahead Logic
module segment_cla(
    input [8:1] A,
    input [8:1] B,
    output G,  // Generate
    output P   // Propagate
);
    assign G = (A[8] & B[8]) | (A[8] & A[7]) | (B[8] & B[7]);
    assign P = A[8] ^ B[8];
endmodule

// 16-bit Segmented Hierarchical Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);
    wire C8;
    wire G1, G2;
    wire P1, P2;

    rca_8bit u1(
      .A(A[8:1]),
      .B(B[8:1]),
      .C_in(Cin),
      .S(S[8:1]),
      .C_out(C8)
    );
    segment_cla u5(
      .A(A[8:1]),
      .B(B[8:1]),
      .G(G1),
      .P(P1)
    );

    rca_8bit u2(
      .A(A[16:9]),
      .B(B[16:9]),
      .C_in(C8),
      .S(S[16:9]),
      .C_out(Cout)
    );
    segment_cla u6(
      .A(A[16:9]),
      .B(B[16:9]),
      .G(G2),
      .P(P2)
    );
endmodule

// 32-bit Carry-Lookahead Adder using 16-bit CLA blocks
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    cla_16bit cla1(
    .A(A[16:1]),
    .B(B[16:1]),
    .Cin(1'b0),
    .S(S[16:1]),
    .Cout(C16)
    );
    cla_16bit cla2(
    .A(A[32:17]),
    .B(B[32:17]),
    .Cin(C16),
    .S(S[32:17]),
    .Cout(C32)
    );
endmodule