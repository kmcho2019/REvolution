module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Compute ~B for two's complement subtraction
    wire [63:0] B_neg = ~B;

    // Slice inputs into 16-bit blocks
    wire [15:0] A0 = A[15:0];
    wire [15:0] A1 = A[31:16];
    wire [15:0] A2 = A[47:32];
    wire [15:0] A3 = A[63:48];

    wire [15:0] B0 = B_neg[15:0];
    wire [15:0] B1 = B_neg[31:16];
    wire [15:0] B2 = B_neg[47:32];
    wire [15:0] B3 = B_neg[63:48];

    // Signals for propagate and generate per 16-bit block
    wire P0, G0, P1, G1, P2, G2, P3, G3;

    // Carry-ins into each 16-bit block
    wire c0 = 1'b1; // initial carry-in for two's complement addition (A + ~B + 1)
    wire c1, c2, c3, c4;

    // Partial sum outputs of each block
    wire [15:0] R0, R1, R2, R3;

    // Instantiate four 16-bit CLAs that output propagate/generate and sum but do NOT chain carry out directly
    cla_16bit_block u_cla0(.A(A0), .B(B0), .cin(c0), .sum(R0), .P(P0), .G(G0));
    cla_16bit_block u_cla1(.A(A1), .B(B1), .cin(c1), .sum(R1), .P(P1), .G(G1));
    cla_16bit_block u_cla2(.A(A2), .B(B2), .cin(c2), .sum(R2), .P(P2), .G(G2));
    cla_16bit_block u_cla3(.A(A3), .B(B3), .cin(c3), .sum(R3), .P(P3), .G(G3));

    // Compute carries into blocks using 4-bit CLA
    // Carry-in vector: c[0] = initial carry-in = 1
    // Outputs c1,c2,c3,c4 correspond to carry-in of blocks 1..4
    wire [4:0] Cblock;
    assign Cblock[0] = c0;
    // Use 4-bit CLA for block carries
    cla_4bit u_cla_block (
        .P({P3, P2, P1, P0}),
        .G({G3, G2, G1, G0}),
        .cin(c0),
        .C(Cblock)
    );

    assign c1 = Cblock[1];
    assign c2 = Cblock[2];
    assign c3 = Cblock[3];
    assign c4 = Cblock[4]; // final carry out (not used for subtraction overflow)

    assign result = {R3, R2, R1, R0};

    // Overflow detection
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 16-bit CLA block: Computes sum = A + B + cin
// Also outputs block propagate (P) and generate (G) signals
module cla_16bit_block (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,
    output wire [15:0] sum,
    output wire        P, // block propagate
    output wire        G  // block generate
);
    wire [15:0] Pn; // propagate per bit
    wire [15:0] Gn; // generate per bit
    wire [16:0] C;  // carry signals

    assign Pn = A ^ B;
    assign Gn = A & B;
    assign C[0] = cin;

    // Compute carries with per-bit lookahead
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin : gen_carry
            assign C[i+1] = Gn[i] | (Pn[i] & C[i]);
        end
    endgenerate

    assign sum = Pn ^ C[15:0];

    // Block propagate is AND of all bit propagates
    assign P = &Pn;

    // Block generate is true if block generates a carry regardless of cin
    // G = G15 + P15G14 + P15P14G13 + ... + P15...P1G0
    // Implement by ripple from MSB to LSB:
    wire [15:0] preG;
    assign preG[0] = Gn[0];
    generate
        for (i=1; i<16; i=i+1) begin : gen_block_g
            assign preG[i] = Gn[i] | (Pn[i] & preG[i-1]);
        end
    endgenerate
    assign G = preG[15];
endmodule


// 4-bit CLA for block carry computation:
// Inputs: 4 block propagates and generates and an initial carry-in
// Outputs: carry vector C[4:0] with C[0] = cin and C[i] = carry into block i
module cla_4bit (
    input  wire [3:0] P,
    input  wire [3:0] G,
    input  wire       cin,
    output wire [4:0] C
);
    assign C[0] = cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
endmodule