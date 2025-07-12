module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Two's complement of B: ~B + 1
    wire [63:0] B_neg;
    wire        carry_out;

    // Instantiate 64-bit carry-lookahead adder for A + (~B) + 1
    cla_64bit u_cla_64bit (
        .A    (A),
        .B    (~B),
        .cin  (1'b1),
        .sum  (result),
        .cout (carry_out)
    );

    // Overflow detection for subtraction A - B:
    // Overflow if A_sign != B_sign and result_sign != A_sign
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule

// 64-bit Carry Lookahead Adder (CLA)
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

    // Generate carry signals using a hierarchical CLA scheme for performance

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign sum = P ^ C[63:0];
    assign cout = C[64];

endmodule