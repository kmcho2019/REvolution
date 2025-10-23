module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Compute complement of B once
    wire [63:0] B_neg = ~B;

    // Carry signals for 64 bits (carry[0] = initial carry-in = 1 for subtraction)
    wire [64:0] carry;

    // Propagate and generate signals
    wire [63:0] P = A ^ B_neg;  // propagate
    wire [63:0] G = A & B_neg;  // generate

    assign carry[0] = 1'b1; // cin=1 for two's complement subtraction

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : carry_chain
            assign carry[i+1] = G[i] | (P[i] & carry[i]);
        end
    endgenerate

    // Sum bits = P XOR carry-in for that bit
    assign result = P ^ carry[63:0];

    // Overflow detection:
    // Overflow occurs if sign bits of A and B differ and sign of result differs from sign of A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow  = (A_sign != B_sign) && (result_sign != A_sign);

endmodule