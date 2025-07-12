module cla_4bit(
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       Gout,
    output       Pout
);
    wire [4:1] G, P;
    wire [5:1] C; // carry signals

    assign G = A & B;   // generate
    assign P = A ^ B;   // propagate

    assign C[1] = Cin;
    // Carry lookahead for 4 bits:
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);

    assign S = P ^ C[4:1];

    // Group propagate and generate for this 4-bit block
    assign Pout = &P; // all propagate ANDed
    assign Gout = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]);
endmodule

module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [3:0] Gsub, Psub;    // group generate/propagate of each 4-bit sub-block
    wire [4:1] Csub;          // carry inputs for each 4-bit sub-block

    // Instantiate four 4-bit CLAs
    cla_4bit cla0(.A(A[4:1]),   .B(B[4:1]),   .Cin(Cin),     .S(S[4:1]),   .Gout(Gsub[0]), .Pout(Psub[0]));
    cla_4bit cla1(.A(A[8:5]),   .B(B[8:5]),   .Cin(Csub[1]), .S(S[8:5]),   .Gout(Gsub[1]), .Pout(Psub[1]));
    cla_4bit cla2(.A(A[12:9]),  .B(B[12:9]),  .Cin(Csub[2]), .S(S[12:9]),  .Gout(Gsub[2]), .Pout(Psub[2]));
    cla_4bit cla3(.A(A[16:13]), .B(B[16:13]), .Cin(Csub[3]), .S(S[16:13]), .Gout(Gsub[3]), .Pout(Psub[3]));

    // Compute carry inputs for each 4-bit block using hierarchical CLA
    assign Csub[1] = Gsub[0] | (Psub[0] & Cin);
    assign Csub[2] = Gsub[1] | (Psub[1] & Csub[1]);
    assign Csub[3] = Gsub[2] | (Psub[2] & Csub[2]);
    assign Cout    = Gsub[3] | (Psub[3] & Csub[3]);
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit lower(.A(A[16:1]),   .B(B[16:1]),   .Cin(1'b0),  .S(S[16:1]),   .Cout(C16));
    cla_16bit upper(.A(A[32:17]),  .B(B[32:17]),  .Cin(C16),   .S(S[32:17]),  .Cout(C32));
endmodule