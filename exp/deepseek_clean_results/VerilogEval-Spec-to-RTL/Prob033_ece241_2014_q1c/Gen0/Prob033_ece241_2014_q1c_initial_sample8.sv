module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    wire [8:0] sum_ext; // Extended sum to catch carry out
    wire a_sign, b_sign, s_sign;

    // Perform the addition with extended bit
    assign sum_ext = {a[7], a} + {b[7], b};
    assign s = sum_ext[7:0];

    // Extract signs
    assign a_sign = a[7];
    assign b_sign = b[7];
    assign s_sign = s[7];

    // Overflow occurs when:
    // 1. Both inputs are positive and result is negative, OR
    // 2. Both inputs are negative and result is positive
    assign overflow = (~a_sign & ~b_sign & s_sign) | (a_sign & b_sign & ~s_sign);

endmodule