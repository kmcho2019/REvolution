module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [7:0] sum;
    wire a_sign, b_sign, sum_sign;
    wire same_sign, sign_mismatch;
    
    assign a_sign = a[7];
    assign b_sign = b[7];
    assign sum_sign = sum[7];
    
    assign sum = a + b;
    assign s = sum;
    
    assign same_sign = ~(a_sign ^ b_sign);
    assign sign_mismatch = a_sign ^ sum_sign;
    assign overflow = same_sign & sign_mismatch;
endmodule