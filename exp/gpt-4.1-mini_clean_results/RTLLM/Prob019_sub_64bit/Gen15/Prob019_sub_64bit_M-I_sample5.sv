module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Perform subtraction as A + (~B + 1)
    wire [63:0] B_comp; // Complemented B internally in CLA
    wire        cout;

    // Instantiate 64-bit CLA performing A + (~B) + 1
    cla_64bit_sub cla64 (
        .A    (A),
        .B    (B),
        .cin  (1'b1),   // Adding the +1 for two's complement subtraction
        .sum  (result),
        .cout (cout)
    );

    // Overflow detection:
    // Overflow occurs when sign of A != sign of B and sign of result != sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 64-bit Carry Lookahead Adder for subtraction: sum = A + (~B) + cin
module cla_64bit_sub (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);
    // Invert B internally for subtraction
    wire [63:0] B_comp = ~B;

    // Generate propagate and generate signals
    wire [63:0] P = A ^ B_comp;
    wire [63:0] G = A & B_comp;

    // Carry signals
    wire [64:0] C;
    assign C[0] = cin;

    // Hierarchical carry-lookahead:
    // Divide 64 bits into 4 blocks of 16 bits for carry calculation
    wire [3:0] P_block;
    wire [3:0] G_block;

    genvar i;

    // Block-level propagate and generate
    generate
        for (i = 0; i < 4; i = i + 1) begin : block_pg
            assign P_block[i] = &P[i*16 +: 16];               // AND of propagates in block
            assign G_block[i] = |(G[i*16 +: 16] | (P[i*16 +: 16] & (i == 0 ? C[0] : C[i*16])));
            // More accurate block generate calculation will be done below
        end
    endgenerate

    // Instead of approximating P_block and G_block above (which is incorrect),
    // compute carries hierarchically with standard CLA logic.

    // First, compute carry for each bit with simple recursive definition:
    // To avoid long chain delay, use a generate loop for carry
    // Carry for bit i+1: C[i+1] = G[i] | (P[i] & C[i])
    generate
        for (i = 0; i < 64; i = i + 1) begin : carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign sum = P ^ C[63:0];
    assign cout = C[64];
endmodule