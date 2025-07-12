module cla_4bit (
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       Cout,
    output       P_group,
    output       G_group
);
    wire [4:1] P; // propagate
    wire [4:1] G; // generate
    wire [5:1] C; // carry: C[1]=Cin, C[5]=Cout

    assign C[1] = Cin;

    // bitwise propagate and generate
    genvar i;
    generate
        for (i = 1; i <=4; i = i+1) begin : pg_bit
            assign P[i] = A[i] ^ B[i];
            assign G[i] = A[i] & B[i];
        end
    endgenerate

    // carry lookahead within 4-bit block:
    // C[2] = G[1] | (P[1]&C[1])
    // C[3] = G[2] | (P[2]&G[1]) | (P[2]&P[1]&C[1])
    // C[4] = G[3] | (P[3]&G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&C[1])
    // C[5] = G[4] | (P[4]&G[3]) | (P[4]&P[3]&G[2]) | (P[4]&P[3]&P[2]&G[1]) | (P[4]&P[3]&P[2]&P[1]&C[1])
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[1]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & C[1]);
    assign C[5] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & C[1]);

    // sum bits
    generate
        for (i = 1; i <= 4; i = i + 1) begin : sum_bit
            assign S[i] = P[i] ^ C[i];
        end
    endgenerate

    assign Cout = C[5];
    assign P_group = &P;                 // group propagate: all bits propagate
    assign G_group = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]);
endmodule


module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [4:1] P_group;  // group propagate from each 4-bit block
    wire [4:1] G_group;  // group generate from each 4-bit block
    wire [5:1] C_group;  // carry input/output to each 4-bit block, C_group[1] = Cin

    assign C_group[1] = Cin;

    // Instantiate four 4-bit CLAs for 16-bit blocks
    cla_4bit cla_blk1 (
        .A        (A[4:1]),
        .B        (B[4:1]),
        .Cin      (C_group[1]),
        .S        (S[4:1]),
        .Cout     (),
        .P_group  (P_group[1]),
        .G_group  (G_group[1])
    );

    cla_4bit cla_blk2 (
        .A        (A[8:5]),
        .B        (B[8:5]),
        .Cin      (C_group[2]),
        .S        (S[8:5]),
        .Cout     (),
        .P_group  (P_group[2]),
        .G_group  (G_group[2])
    );

    cla_4bit cla_blk3 (
        .A        (A[12:9]),
        .B        (B[12:9]),
        .Cin      (C_group[3]),
        .S        (S[12:9]),
        .Cout     (),
        .P_group  (P_group[3]),
        .G_group  (G_group[3])
    );

    cla_4bit cla_blk4 (
        .A        (A[16:13]),
        .B        (B[16:13]),
        .Cin      (C_group[4]),
        .S        (S[16:13]),
        .Cout     (),
        .P_group  (P_group[4]),
        .G_group  (G_group[4])
    );

    // Carry lookahead for 4 groups:
    // C_group[2] = G_group[1] | (P_group[1] & C_group[1])
    // C_group[3] = G_group[2] | (P_group[2] & G_group[1]) | (P_group[2] & P_group[1] & C_group[1])
    // C_group[4] = G_group[3] | (P_group[3] & G_group[2]) | (P_group[3] & P_group[2] & G_group[1]) | (P_group[3] & P_group[2] & P_group[1] & C_group[1])
    // Cout       = G_group[4] | (P_group[4] & G_group[3]) | (P_group[4] & P_group[3] & G_group[2]) | (P_group[4] & P_group[3] & P_group[2] & G_group[1]) | (P_group[4] & P_group[3] & P_group[2] & P_group[1] & C_group[1])
    assign C_group[2] = G_group[1] | (P_group[1] & C_group[1]);
    assign C_group[3] = G_group[2] | (P_group[2] & G_group[1]) | (P_group[2] & P_group[1] & C_group[1]);
    assign C_group[4] = G_group[3] | (P_group[3] & G_group[2]) | (P_group[3] & P_group[2] & G_group[1]) | (P_group[3] & P_group[2] & P_group[1] & C_group[1]);

    assign Cout = G_group[4] | (P_group[4] & G_group[3]) | (P_group[4] & P_group[3] & G_group[2]) | (P_group[4] & P_group[3] & P_group[2] & G_group[1]) | (P_group[4] & P_group[3] & P_group[2] & P_group[1] & C_group[1]);

endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    // Lower 16-bit CLA block
    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16)
    );

    // Upper 16-bit CLA block
    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32)
    );
endmodule