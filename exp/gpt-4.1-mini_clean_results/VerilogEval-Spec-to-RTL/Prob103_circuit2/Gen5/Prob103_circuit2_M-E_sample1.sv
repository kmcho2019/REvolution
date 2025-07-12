module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire [1:0] sum1, sum2;
wire [2:0] total_sum;

// Sum a and b (each 1 bit) to 2-bit result
assign sum1 = a + b;

// Sum c and d to 2-bit result
assign sum2 = c + d;

// Sum the two partial sums to get total count (range 0 to 4)
assign total_sum = sum1 + sum2;

// Parity is even when total number of ones is even.
// q = 1 if even parity, else 0.
// Since parity bit = inverse of LSB of count
assign q = ~total_sum[0];

endmodule