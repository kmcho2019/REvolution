module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

assign s = a + b;

// Calculate the sign bit of a, b, and the sum
wire a_sign = a[7];
wire b_sign = b[7];
wire s_sign = s[7];

// Determine if an overflow has occurred
// An overflow occurs when the signs of a and b are the same and different from the sign of the sum
assign overflow = (a_sign == b_sign) && (a_sign != s_sign);

endmodule