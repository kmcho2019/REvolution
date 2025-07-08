module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    wire [7:0] sum;
    wire a_sign, b_sign, s_sign;
    
    assign sum = a + b;
    assign s = sum;
    
    assign a_sign = a[7];
    assign b_sign = b[7];
    assign s_sign = sum[7];
    
    assign overflow = (~a_sign & ~b_sign & s_sign) |  // Positive + Positive = Negative
                     (a_sign & b_sign & ~s_sign);    // Negative + Negative = Positive

endmodule