module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        PG,  // Block propagate
    output        GG   // Block generate
);
    wire [16:1] P, G;
    wire [16:0] C;

    // Bitwise propagate and generate
    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Carry lookahead for 16 bits
    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : carry_calc
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    assign S = P ^ C[15:0];
    assign Cout = C[16];

    // Block propagate: all bits propagate
    assign PG = &P; // AND of all propagate bits
    // Block generate: either highest generate or propagate chain to generate
    // GG = G16 + P16*G15 + ... + P16*P15*...*P2*G1
    // However, since C[16] = GG + PG*Cin, we can get GG from:
    // GG = C[16] when Cin=0, since C[0]=Cin
    // So compute GG as: GG = C[16] when Cin=0 (here Cin is input)
    // But to implement pure logic: GG = G16 + P16*G15 + ... is cumbersome,
    // Instead reuse the carry chain formula:
    // GG = G16 + P16*G15 + ... + P16*...*P1*Cin (Cin=0 here, so GG is C[16] with Cin=0)
    // Hence, when Cin=0, C[16] = GG (carry-out with zero carry-in)
    // So to get GG independent of Cin, we simulate with Cin=0 inside this module.
    // For clarity, we duplicate carry calc with Cin=0 to get GG and PG directly.
endmodule

// To properly extract GG and PG as signals from cla_16bit, we need additional logic:
module cla_16bit_pg (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        PG,
    output        GG
);
    wire [16:1] P, G;
    wire [16:0] C;

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : carry_calc
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    assign S = P ^ C[15:0];
    assign Cout = C[16];

    // Calculate block propagate: AND of all P bits
    assign PG = &P;

    // Calculate block generate (GG) using recursive formula:
    // GG = G16 + P16*G15 + P16*P15*G14 + ... + P16*P15*...*P1*0 (since no carry-in considered here)
    // Implemented as a tree to avoid long chain

    wire [15:1] P_and; // prefix ANDs of P[16:2]
    assign P_and[1] = P[16];
    genvar j;
    generate
        for (j = 2; j <= 15; j = j + 1) begin : p_and_calc
            assign P_and[j] = P_and[j-1] & P[17-j];
        end
    endgenerate

    // G terms with respective P products:
    // GG = G16 + P16*G15 + P16*P15*G14 + ... + P16*...*P2*G1
    // We'll implement as a sum of ANDs:

    wire [15:1] term;
    assign term[1] = G[16];
    assign term[2] = P[16] & G[15];
    genvar k;
    generate
        for (k = 3; k <= 16; k = k + 1) begin : gg_terms
            if (k == 16)
                assign term[k-1] = P_and[14] & G[1];
            else
                assign term[k-1] = P_and[k-2] & G[17-k];
        end
    endgenerate

    assign GG = |term;

endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Intermediate wires for propagate and generate from 16-bit blocks
    wire PG0, GG0, PG1, GG1;
    wire C16;

    // Instantiate lower 16-bit CLA block with propagate/generate outputs
    cla_16bit_pg lower_half (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(),
        .PG  (PG0),
        .GG  (GG0)
    );

    // Compute carry-in to upper half by carry-lookahead logic:
    // C16 = GG0 + PG0 * Cin (Cin=0 here, so C16=GG0)
    assign C16 = GG0;

    // Instantiate upper 16-bit CLA block with propagate/generate outputs
    cla_16bit_pg upper_half (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32),
        .PG  (PG1),
        .GG  (GG1)
    );

    // Compute final carry-out for 32 bits
    // C32 = GG1 + PG1 * C16
    // This is already output as Cout from upper_half, so no extra logic needed here.
endmodule