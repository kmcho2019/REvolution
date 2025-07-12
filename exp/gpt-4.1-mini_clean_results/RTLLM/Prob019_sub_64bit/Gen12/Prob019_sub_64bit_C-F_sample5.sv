module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Split inputs into two 32-bit halves
    wire [31:0] res_lower, res_upper;
    wire        borrow_lower, borrow_upper;

    // Lower 32-bit subtractor with borrow in = 0 (no borrow initially)
    sub_32bit_cla sub_lower (
        .A    (A[31:0]),
        .B    (B[31:0]),
        .cin  (1'b0),
        .result (res_lower),
        .cout (borrow_lower)
    );

    // Upper 32-bit subtractor with borrow from lower subtractor
    sub_32bit_cla sub_upper (
        .A    (A[63:32]),
        .B    (B[63:32]),
        .cin  (borrow_lower),
        .result (res_upper),
        .cout (borrow_upper)
    );

    assign result = {res_upper, res_lower};

    // Overflow detection:
    // overflow = (A_sign != B_sign) && (result_sign != A_sign)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 32-bit subtractor using two 16-bit CLA subtractors chained with borrow
module sub_32bit_cla (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        cin,      // borrow in
    output wire [31:0] result,
    output wire        cout      // borrow out
);
    wire carry_mid;

    // Lower 16 bits subtractor
    sub_16bit_cla sub_lower (
        .A      (A[15:0]),
        .B      (B[15:0]),
        .cin    (cin),
        .result (result[15:0]),
        .cout   (carry_mid)
    );

    // Upper 16 bits subtractor
    sub_16bit_cla sub_upper (
        .A      (A[31:16]),
        .B      (B[31:16]),
        .cin    (carry_mid),
        .result (result[31:16]),
        .cout   (cout)
    );

endmodule


// 16-bit subtractor composed of two 8-bit CLA subtractors chained internally with borrow
module sub_16bit_cla (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,      // borrow in
    output wire [15:0] result,
    output wire        cout      // borrow out
);
    wire carry_mid;

    // Lower 8 bits subtractor
    cla_8bit_sub cla_low (
        .A    (A[7:0]),
        .B    (B[7:0]),
        .cin  (cin),
        .sum  (result[7:0]),
        .cout (carry_mid)
    );

    // Upper 8 bits subtractor
    cla_8bit_sub cla_high (
        .A    (A[15:8]),
        .B    (B[15:8]),
        .cin  (carry_mid),
        .sum  (result[15:8]),
        .cout (cout)
    );

endmodule


// 8-bit CLA subtractor implementing sum = A + (~B) + cin
module cla_8bit_sub (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       cin,     // borrow in
    output wire [7:0] sum,
    output wire       cout     // borrow out
);
    // Complement B for subtraction: A - B - borrow_in = A + ~B + borrow_in
    wire [7:0] B_neg = ~B;

    wire [7:0] P;   // propagate signals
    wire [7:0] G;   // generate signals
    wire [8:0] C;   // carry signals: C[0] = cin

    assign P = A ^ B_neg;
    assign G = A & B_neg;
    assign C[0] = cin;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign sum = P ^ C[7:0];
    assign cout = C[8];
endmodule