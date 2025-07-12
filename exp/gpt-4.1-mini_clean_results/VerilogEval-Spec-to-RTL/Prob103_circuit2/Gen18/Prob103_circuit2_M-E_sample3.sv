module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire [1:0] sum_ab;
    wire [1:0] sum_cd;
    wire [2:0] total_sum;

    // Sum of two bits: a + b
    assign sum_ab = a + b;  // 2-bit result

    // Sum of two bits: c + d
    assign sum_cd = c + d;  // 2-bit result

    // Total sum = sum_ab + sum_cd (max 4)
    assign total_sum = sum_ab + sum_cd; // 3-bit result, range 0-4

    // Output q = 1 if total_sum is even, else 0
    // total_sum can be 0,1,2,3,4; even values are 0,2,4
    assign q = (total_sum == 0) || (total_sum == 2) || (total_sum == 4);

endmodule