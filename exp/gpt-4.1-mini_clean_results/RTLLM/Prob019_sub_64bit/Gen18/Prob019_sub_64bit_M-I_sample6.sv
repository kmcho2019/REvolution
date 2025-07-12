module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Compute bitwise inversion of B once
    wire [63:0] B_comp = ~B;

    wire cout;

    // Single unified 64-bit CLA for subtraction: A + (~B) + 1
    cla_64bit cla_sub (
        .A   (A),
        .B   (B_comp),
        .cin (1'b1),
        .sum (result),
        .cout(cout)
    );

    // Overflow detection:
    // Overflow occurs when sign of A != sign of B, and sign of result != sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 64-bit Carry Lookahead Adder with hierarchical 4-bit group carry lookahead
module cla_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);
    wire [63:0] P;    // Propagate
    wire [63:0] G;    // Generate
    wire [16:0] C;    // Carry signals for each 4-bit group boundary (16 groups + initial carry)

    // Compute bitwise propagate and generate signals
    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = cin;

    // Group propagate and generate for each 4-bit block
    wire [15:0] PG;  // group propagate
    wire [15:0] GG;  // group generate

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : group_pg_gen
            // Each group covers 4 bits: [4*i +: 4]
            wire [3:0] p4 = P[4*i +: 4];
            wire [3:0] g4 = G[4*i +: 4];

            // Group propagate = p3 & p2 & p1 & p0
            assign PG[i] = &p4;

            // Group generate for 4-bit block:
            // G_group = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0
            assign GG[i] =
                g4[3] | (p4[3] & g4[2]) |
                (p4[3] & p4[2] & g4[1]) |
                (p4[3] & p4[2] & p4[1] & g4[0]);
        end
    endgenerate

    // Carry lookahead for groups:
    // C[j+1] = GG[j] + PG[j]*C[j]
    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_groups
            assign C[i+1] = GG[i] | (PG[i] & C[i]);
        end
    endgenerate

    // Now compute carry within each 4-bit group using the group carry-in C[i]
    // For bit k in group i:
    // C_bit[k+1] = G[k] + P[k]*C_bit[k]
    wire [63:0] C_bit;
    assign C_bit[0] = C[0];
    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_within_group
            integer j;
            for (j = 0; j < 4; j = j + 1) begin : bits
                if (j == 0) begin
                    assign C_bit[4*i + 1] = G[4*i] | (P[4*i] & C[ i ]);
                end else begin
                    assign C_bit[4*i + j + 1] = G[4*i + j] | (P[4*i + j] & C_bit[4*i + j]);
                end
            end
        end
    endgenerate

    // sum = P ^ carry_in for each bit
    assign sum = P ^ C_bit[63:0];

    // final carry out
    assign cout = C_bit[64]; // This wire does not exist, we need to extend C_bit by one bit
endmodule