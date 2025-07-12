module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Internal carry signals between 8-bit CLA blocks
    wire [8:0] carry;
    assign carry[0] = 1'b1; // initial carry-in = 1 for two's complement subtraction (A + ~B + 1)

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : sub_blocks
            cla_8bit_sub block8 (
                .A      (A[i*8 +: 8]),
                .B      (B[i*8 +: 8]),
                .cin    (carry[i]),
                .sum    (result[i*8 +: 8]),
                .cout   (carry[i+1])
            );
        end
    endgenerate

    // Overflow detection for subtraction: overflow if A_sign != B_sign and result_sign != A_sign
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow  = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 8-bit CLA Subtractor block performing: sum = A + (~B) + cin
module cla_8bit_sub (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       cin,    // carry-in for this block (equals borrow_in for subtraction)
    output wire [7:0] sum,
    output wire       cout    // carry-out from this block
);
    wire [7:0] B_neg = ~B; // bitwise complement of B

    wire [7:0] P; // propagate signals
    wire [7:0] G; // generate signals
    wire [8:0] C; // carry signals

    assign P = A ^ B_neg;
    assign G = A & B_neg;
    assign C[0] = cin;

    // Carry lookahead logic for 8 bits:
    // C[i+1] = G[i] | (P[i] & C[i])
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : carry_loop
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign sum = P ^ C[7:0];
    assign cout = C[8];

endmodule