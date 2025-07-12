module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [31:0] B_comp_lower = ~B[31:0];
    wire [31:0] B_comp_upper = ~B[63:32];

    wire        carry_lower;
    wire        carry_upper;

    wire [31:0] res_lower;
    wire [31:0] res_upper;

    // Lower 32-bit CLA: sum = A_lower + ~B_lower + 1 (carry_in = 1)
    cla_32bit cla_lower (
        .A   (A[31:0]),
        .B   (B_comp_lower),
        .cin (1'b1),
        .sum (res_lower),
        .cout(carry_lower)
    );

    // Upper 32-bit CLA: sum = A_upper + ~B_upper + carry from lower
    cla_32bit cla_upper (
        .A   (A[63:32]),
        .B   (B_comp_upper),
        .cin (carry_lower),
        .sum (res_upper),
        .cout(carry_upper)
    );

    assign result = {res_upper, res_lower};

    // Overflow detection:
    // Overflow when sign(A) != sign(B) and sign(result) != sign(A)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 32-bit Carry Lookahead Adder (CLA) module
module cla_32bit (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        cin,
    output wire [31:0] sum,
    output wire        cout
);
    wire [31:0] P;      // Propagate signals
    wire [31:0] G;      // Generate signals
    wire [32:0] C;      // Carry signals

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = cin;

    // Generate carries using carry-lookahead logic
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign sum = P ^ C[31:0];
    assign cout = C[32];
endmodule