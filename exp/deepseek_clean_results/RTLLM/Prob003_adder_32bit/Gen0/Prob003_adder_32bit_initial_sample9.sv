module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Pg,
    output Gg,
    output Cout
);

    wire [3:0] P, G;
    wire [3:1] C;

    // Generate and Propagate signals
    assign P = A ^ B;
    assign G = A & B;

    // Carry calculations
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);

    // Sum calculation
    assign S[0] = P[0] ^ Cin;
    assign S[1] = P[1] ^ C[1];
    assign S[2] = P[2] ^ C[2];
    assign S[3] = P[3] ^ C[3];

    // Block propagate and generate
    assign Pg = &P;
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);

endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Pg,
    output Gg,
    output Cout
);

    wire [3:0] P_block, G_block;
    wire [3:1] C;

    // Instantiate four 4-bit CLA blocks
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .Pg(P_block[0]), .Gg(G_block[0]), .Cout());
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(C[1]), .S(S[7:4]), .Pg(P_block[1]), .Gg(G_block[1]), .Cout());
    cla_4bit cla2 (.A(A[11:8]), .B(B[11:8]), .Cin(C[2]), .S(S[11:8]), .Pg(P_block[2]), .Gg(G_block[2]), .Cout());
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(C[3]), .S(S[15:12]), .Pg(P_block[3]), .Gg(G_block[3]), .Cout());

    // Carry lookahead logic for 16-bit block
    assign C[1] = G_block[0] | (P_block[0] & Cin);
    assign C[2] = G_block[1] | (P_block[1] & G_block[0]) | (P_block[1] & P_block[0] & Cin);
    assign C[3] = G_block[2] | (P_block[2] & G_block[1]) | (P_block[2] & P_block[1] & G_block[0]) | (P_block[2] & P_block[1] & P_block[0] & Cin);
    assign Cout = G_block[3] | (P_block[3] & G_block[2]) | (P_block[3] & P_block[2] & G_block[1]) | (P_block[3] & P_block[2] & P_block[1] & G_block[0]) | (P_block[3] & P_block[2] & P_block[1] & P_block[0] & Cin);

    // Block propagate and generate
    assign Pg = &P_block;
    assign Gg = G_block[3] | (P_block[3] & G_block[2]) | (P_block[3] & P_block[2] & G_block[1]) | (P_block[3] & P_block[2] & P_block[1] & G_block[0]);

endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire [16:1] A_low = A[16:1];
    wire [16:1] B_low = B[16:1];
    wire [32:17] A_high = A[32:17];
    wire [32:17] B_high = B[32:17];
    wire [16:1] S_low;
    wire [32:17] S_high;
    wire Pg_low, Gg_low, Cout_low;

    // Instantiate two 16-bit CLA blocks
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Pg(Pg_low),
        .Gg(Gg_low),
        .Cout(Cout_low)
    );

    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cout_low),
        .S(S_high),
        .Pg(),
        .Gg(),
        .Cout(C32)
    );

    // Combine results
    assign S = {S_high, S_low};

endmodule