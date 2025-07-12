module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire [2:0] sum;

assign sum = a + b + c + d;  // 3-bit sum of four 1-bit inputs

// q is 1 if the number of ones is even, i.e., sum LSB is 0
assign q = ~sum[0];

endmodule