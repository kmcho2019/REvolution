module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Two's complement subtraction: A - B = A + (~B) + 1
    wire [63:0] B_neg = ~B;

    wire [63:0] P; // propagate signals
    wire [63:0] G; // generate signals
    wire [64:0] C; // carry signals

    assign P = A ^ B_neg;
    assign G = A & B_neg;

    assign C[0] = 1'b1;  // initial carry-in = 1 for two's complement addition

    genvar i;
    generate
        for(i = 0; i < 64; i = i + 1) begin : carry_calc
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign result = P ^ C[63:0];

    // Overflow detection: occurs if sign of A and B differ and sign of result differs from A's sign
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule