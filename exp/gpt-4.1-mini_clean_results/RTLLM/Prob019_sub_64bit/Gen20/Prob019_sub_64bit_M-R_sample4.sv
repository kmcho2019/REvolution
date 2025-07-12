module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Two's complement subtraction: result = A + (~B) + 1

    wire [63:0] B_neg = ~B;          // bitwise complement of B
    wire [63:0] P;                   // propagate signals
    wire [63:0] G;                   // generate signals
    wire [64:0] carry;               // carry signals, carry[0] = 1 for +1 in subtraction

    assign carry[0] = 1'b1;          // initial carry in for two's complement add of (~B) + 1

    // Generate propagate and generate bits
    assign P = A ^ B_neg;
    assign G = A & B_neg;

    // Generate carry signals using carry lookahead in parallel
    // carry[i+1] = G[i] | (P[i] & carry[i])
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : carry_gen
            assign carry[i+1] = G[i] | (P[i] & carry[i]);
        end
    endgenerate

    // Compute result bits: sum = P ^ carry_in
    // carry_in for bit i is carry[i]
    assign result = P ^ carry[63:0];

    // Overflow detection:
    // overflow if sign of A != sign of B and sign of result != sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow  = (A_sign != B_sign) && (result_sign != A_sign);

endmodule