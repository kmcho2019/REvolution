module cla_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] S,
    output       Cout,
    output       Pout,
    output       Gout
);
    wire [3:0] P = A ^ B;
    wire [3:0] G = A & B;

    wire C1, C2, C3;

    assign C1 = G[0] | (P[0] & Cin);
    assign C2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);

    assign S = P ^ {C3, C2, C1, Cin};

    // Block propagate and generate outputs for hierarchical use
    assign Pout = &P; // all propagate bits ANDed
    assign Gout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [3:0] P_blk, G_blk;
    wire [3:0] C;

    // Instantiate four 4-bit CLA blocks
    cla_4bit cla0 (.A(A[3:0]),   .B(B[3:0]),   .Cin(Cin),   .S(S[3:0]),   .Cout(),     .Pout(P_blk[0]), .Gout(G_blk[0]));
    cla_4bit cla1 (.A(A[7:4]),   .B(B[7:4]),   .Cin(C[1]),  .S(S[7:4]),   .Cout(),     .Pout(P_blk[1]), .Gout(G_blk[1]));
    cla_4bit cla2 (.A(A[11:8]),  .B(B[11:8]),  .Cin(C[2]),  .S(S[11:8]),  .Cout(),     .Pout(P_blk[2]), .Gout(G_blk[2]));
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(C[3]),  .S(S[15:12]), .Cout(),     .Pout(P_blk[3]), .Gout(G_blk[3]));

    // Carry generation for 4-bit groups
    assign C[0] = 
        G_blk[0] | (P_blk[0] & Cin);
    assign C[1] = 
        G_blk[1] | (P_blk[1] & G_blk[0]) | (P_blk[1] & P_blk[0] & Cin);
    assign C[2] = 
        G_blk[2] | (P_blk[2] & G_blk[1]) | (P_blk[2] & P_blk[1] & G_blk[0]) | (P_blk[2] & P_blk[1] & P_blk[0] & Cin);
    assign C[3] = 
        G_blk[3] | (P_blk[3] & G_blk[2]) | (P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[3] & P_blk[2] & P_blk[1] & G_blk[0]) 
        | (P_blk[3] & P_blk[2] & P_blk[1] & P_blk[0] & Cin);

    assign Cout = C[3];
endmodule

module adder_32bit(
    input  [31:0] A,
    input  [31:0] B,
    output [31:0] S,
    output        C32
);
    wire C16;

    cla_16bit cla_low (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout(C16)
    );

    cla_16bit cla_high (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .Cout(C32)
    );
endmodule