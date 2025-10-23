// 4-bit carry-lookahead adder
module cla_4bit(
    input  [4:1] A,
    input  [4:1] B,
    output [4:1] S,
    output C_out,
    input  C_in
);
    
    wire [4:1] G, P;
    wire [4:1] C;

    // Compute generate (G) and propagate (P) signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] | B[2];
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] | B[3];
    assign G[4] = A[4] & B[4];
    assign P[4] = A[4] | B[4];

    // Compute carry signals
    assign C[1] = G[1] | (P[1] & C_in);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);

    // Compute sum signals
    assign S[1] = A[1] ^ B[1] ^ C_in;
    assign S[2] = A[2] ^ B[2] ^ C[1];
    assign S[3] = A[3] ^ B[3] ^ C[2];
    assign S[4] = A[4] ^ B[4] ^ C[3];

    // Output carry signal
    assign C_out = C[4];

endmodule

// 16-bit carry-lookahead adder
module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    output [16:1] S,
    output C_out,
    input  C_in
);
    
    wire C1, C2, C3, C4;

    // Instantiate 4-bit CLA blocks
    cla_4bit cla1(
       .A(A[4:1]),
       .B(B[4:1]),
       .S(S[4:1]),
       .C_out(C1),
       .C_in(C_in)
    );

    cla_4bit cla2(
       .A(A[8:5]),
       .B(B[8:5]),
       .S(S[8:5]),
       .C_out(C2),
       .C_in(C1)
    );

    cla_4bit cla3(
       .A(A[12:9]),
       .B(B[12:9]),
       .S(S[12:9]),
       .C_out(C3),
       .C_in(C2)
    );

    cla_4bit cla4(
       .A(A[16:13]),
       .B(B[16:13]),
       .S(S[16:13]),
       .C_out(C_out),
       .C_in(C3)
    );

endmodule

// 32-bit carry-lookahead adder
module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output C32,
    input  C_in
);
    
    wire C16;

    // Instantiate 16-bit CLA blocks
    cla_16bit cla1(
       .A(A[16:1]),
       .B(B[16:1]),
       .S(S[16:1]),
       .C_out(C16),
       .C_in(C_in)
    );

    cla_16bit cla2(
       .A(A[32:17]),
       .B(B[32:17]),
       .S(S[32:17]),
       .C_out(C32),
       .C_in(C16)
    );

endmodule