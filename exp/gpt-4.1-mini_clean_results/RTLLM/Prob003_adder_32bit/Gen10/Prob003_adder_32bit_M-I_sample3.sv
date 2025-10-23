module cla_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] S,
    output       Cout,
    output       Pout,  // block propagate
    output       Gout   // block generate
);
    wire [3:0] P = A ^ B;       // Propagate signals
    wire [3:0] G = A & B;       // Generate signals

    wire c1, c2, c3;

    // Carry signals inside 4-bit block
    assign c1 = G[0] | (P[0] & Cin);
    assign c2 = G[1] | (P[1] & c1);
    assign c3 = G[2] | (P[2] & c2);
    assign Cout = G[3] | (P[3] & c3);

    assign S = P ^ {c3,c2,c1,Cin};

    // Block propagate: all propagate bits are 1
    assign Pout = &P;
    // Block generate: block generates carry regardless of Cin
    assign Gout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [3:0] P_blk, G_blk;        // Block propagate and generate signals
    wire [4:0] c;                   // Carry signals between blocks (5 signals: c[0] to c[4])
    assign c[0] = Cin;

    wire [3:0] s0, s1, s2, s3;
    wire cout0, cout1, cout2, cout3;

    // Instantiate four 4-bit CLA blocks
    cla_4bit cla_blk0(.A(A[3:0]),   .B(B[3:0]),   .Cin(c[0]), .S(s0), .Cout(cout0), .Pout(P_blk[0]), .Gout(G_blk[0]));
    cla_4bit cla_blk1(.A(A[7:4]),   .B(B[7:4]),   .Cin(c[1]), .S(s1), .Cout(cout1), .Pout(P_blk[1]), .Gout(G_blk[1]));
    cla_4bit cla_blk2(.A(A[11:8]),  .B(B[11:8]),  .Cin(c[2]), .S(s2), .Cout(cout2), .Pout(P_blk[2]), .Gout(G_blk[2]));
    cla_4bit cla_blk3(.A(A[15:12]), .B(B[15:12]), .Cin(c[3]), .S(s3), .Cout(cout3), .Pout(P_blk[3]), .Gout(G_blk[3]));

    // Carry lookahead for block carries
    assign c[1] = G_blk[0] | (P_blk[0] & c[0]);
    assign c[2] = G_blk[1] | (P_blk[1] & c[1]);
    assign c[3] = G_blk[2] | (P_blk[2] & c[2]);
    assign c[4] = G_blk[3] | (P_blk[3] & c[3]);

    assign Cout = c[4];

    assign S = {s3, s2, s1, s0};
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;
    
    // Internal zero-based slices
    wire [15:0] A_low  = A[16:1];
    wire [15:0] B_low  = B[16:1];
    wire [15:0] A_high = A[32:17];
    wire [15:0] B_high = B[32:17];

    wire [15:0] S_low, S_high;

    cla_16bit cla_lower (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16)
    );

    cla_16bit cla_upper (
        .A(A_high),
        .B(B_high),
        .Cin(C16),
        .S(S_high),
        .Cout(C32)
    );

    // Output assignment with 1-based indexing
    assign S[16:1]  = S_low;
    assign S[32:17] = S_high;
endmodule