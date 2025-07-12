module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output      overflow
);

    wire [8:0] sum;
    wire       a_sign, b_sign, sum_sign;

    assign sum     = $signed(a) + $signed(b);
    assign s       = sum[7:0];
    assign a_sign  = a[7];  // Sign bit of a
    assign b_sign  = b[7];  // Sign bit of b
    assign sum_sign = sum[8]; // Sign bit of the sum (note: we are considering the 9-bit sum here)
    assign overflow = ((a_sign == 0 && b_sign == 0 && sum_sign == 1) || (a_sign == 1 && b_sign == 1 && sum_sign == 0));

endmodule