module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Perform subtraction as addition of A + (~B) + 1 with single 64-bit CLA
    wire [63:0] B_neg = ~B;
    wire cin = 1'b1; // Adding +1 for two's complement subtraction

    wire cout;

    cla_64bit u_cla_64bit (
        .A   (A),
        .B   (B_neg),
        .cin (cin),
        .sum (result),
        .cout(cout)
    );

    // Overflow detection:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 64-bit Carry Lookahead Adder
module cla_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);
    wire [63:0] P; // propagate
    wire [63:0] G; // generate
    wire [64:0] C; // carry chain

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = cin;

    // Hierarchical carry lookahead for 64 bits:
    // For simplicity and synthesis friendliness,
    // generate carries using a prefix approach in 4-bit blocks.

    // Level 1: 4-bit group propagate and generate
    wire [15:0] Pg; // propagate per 4-bit group
    wire [15:0] Gg; // generate per 4-bit group

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_4bit_pg
            // Group propagate: AND of 4 propagates
            assign Pg[i] = &P[(i*4)+3 -: 4];
            // Group generate: G[i*4+3] or (P[i*4+3] & G[i*4+2]) or ... cascading down
            assign Gg[i] = G[(i*4)+3]
                          | (P[(i*4)+3] & G[(i*4)+2])
                          | (P[(i*4)+3] & P[(i*4)+2] & G[(i*4)+1])
                          | (P[(i*4)+3] & P[(i*4)+2] & P[(i*4)+1] & G[(i*4)+0]);
        end
    endgenerate

    // Level 2: calculate carry-in for each 4-bit group using Pg, Gg and C[0]
    wire [16:0] Cg; // carries for groups
    assign Cg[0] = C[0];
    generate
        for (i = 0; i < 16; i = i +1) begin : gen_cg
            assign Cg[i+1] = Gg[i] | (Pg[i] & Cg[i]);
        end
    endgenerate

    // Now calculate carry for each bit within the 4-bit groups
    // For each 4-bit group, C for bits inside can be generated similarly

    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_bit_carries
            // Generate carries inside group i:
            // base carry_in = Cg[i]
            wire c0 = Cg[i];
            wire p0 = P[i*4 + 0];
            wire g0 = G[i*4 + 0];
            wire p1 = P[i*4 + 1];
            wire g1 = G[i*4 + 1];
            wire p2 = P[i*4 + 2];
            wire g2 = G[i*4 + 2];
            wire p3 = P[i*4 + 3];
            wire g3 = G[i*4 + 3];

            // Compute carries for bits in the group:
            assign C[i*4 + 1] = g0 | (p0 & c0);
            assign C[i*4 + 2] = g1 | (p1 & C[i*4 + 1]);
            assign C[i*4 + 3] = g2 | (p2 & C[i*4 + 2]);
            assign C[i*4 + 4] = g3 | (p3 & C[i*4 + 3]);
        end
    endgenerate

    // sum bits
    assign sum = P ^ C[63:0];
    assign cout = C[64];

endmodule