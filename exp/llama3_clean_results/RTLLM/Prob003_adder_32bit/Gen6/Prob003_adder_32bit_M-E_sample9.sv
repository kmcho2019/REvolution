// 8-bit Ripple-Carry Adder
module rca_8bit(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);

    wire [7:1] C;

    // Calculate Sum and Carry signals
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

    // Calculate Generate and Propagate signals for the segment
    assign G = (A[8] & B[8]) | (A[8] & A[7]) | (B[8] & B[7]);
    assign P = A[8] ^ B[8];

endmodule

// 32-bit Segmented Hierarchical Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire C8, C16, C24;
    wire G1, G2, G3, G4;
    wire P1, P2, P3, P4;

    // Segment 1
    rca_8bit u1(
       .A(A[8:1]),
       .B(B[8:1]),
       .C_in(1'b0),
       .S(S[8:1]),
       .C_out(C8)
    );
    segment_cla u5(
       .A(A[8:1]),
       .B(B[8:1]),
       .G(G1),
       .P(P1)
    );

    // Segment 2
    rca_8bit u2(
       .A(A[16:9]),
       .B(B[16:9]),
       .C_in(C8),
       .S(S[16:9]),
       .C_out(C16)
    );
    segment_cla u6(
       .A(A[16:9]),
       .B(B[16:9]),
       .G(G2),
       .P(P2)
    );

    // Segment 3
    rca_8bit u3(
       .A(A[24:17]),
       .B(B[24:17]),
       .C_in(C16),
       .S(S[24:17]),
       .C_out(C24)
    );
    segment_cla u7(
       .A(A[24:17]),
       .B(B[24:17]),
       .G(G3),
       .P(P3)
    );

    // Segment 4
    rca_8bit u4(
       .A(A[32:25]),
       .B(B[32:25]),
       .C_in(C24),
       .S(S[32:25]),
       .C_out(C32)
    );
    segment_cla u8(
       .A(A[32:25]),
       .B(B[32:25]),
       .G(G4),
       .P(P4)
    );

endmodule