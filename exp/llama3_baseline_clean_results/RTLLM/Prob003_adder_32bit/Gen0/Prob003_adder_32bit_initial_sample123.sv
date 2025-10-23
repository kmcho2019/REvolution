// 4-bit CLA block
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input Cin,
    output [4:1] S,
    output Cout
);

    wire [4:1] G, P;
    wire [3:1] C;

    // Calculate generate (G) and propagate (P) signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] ^ B[1];
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] ^ B[2];
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] ^ B[3];
    assign G[4] = A[4] & B[4];
    assign P[4] = A[4] ^ B[4];

    // Calculate carry signals
    assign C[1] = G[1] | (P[1] & Cin);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);

    // Calculate sum signals
    assign S[1] = P[1] ^ Cin;
    assign S[2] = P[2] ^ C[1];
    assign S[3] = P[3] ^ C[2];
    assign S[4] = P[4] ^ C[3];

    // Calculate carry-out signal
    assign Cout = G[4] | (P[4] & C[3]);

endmodule

// 16-bit CLA block using 4-bit CLA blocks
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);

    wire [4:1] G1, G2, G3, G4;
    wire [4:1] P1, P2, P3, P4;
    wire Cout1, Cout2, Cout3;

    // 4-bit CLA blocks
    cla_4bit u1(.A(A[4:1]), .B(B[4:1]), .Cin(Cin), .S(S[4:1]), .Cout(Cout1));
    cla_4bit u2(.A(A[8:5]), .B(B[8:5]), .Cin(Cout1), .S(S[8:5]), .Cout(Cout2));
    cla_4bit u3(.A(A[12:9]), .B(B[12:9]), .Cin(Cout2), .S(S[12:9]), .Cout(Cout3));
    cla_4bit u4(.A(A[16:13]), .B(B[16:13]), .Cin(Cout3), .S(S[16:13]), .Cout(Cout));

endmodule

// 32-bit CLA adder using 16-bit CLA blocks
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire Cout1;

    // 16-bit CLA blocks
    cla_16bit u1(.A(A[16:1]), .B(B[16:1]), .Cin(1'b0), .S(S[16:1]), .Cout(Cout1));
    cla_16bit u2(.A(A[32:17]), .B(B[32:17]), .Cin(Cout1), .S(S[32:17]), .Cout(C32));

endmodule