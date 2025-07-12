module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire [2:0] sum;

    assign sum = a + b + c + d; // 3-bit sum to hold max value 4
    assign q = ~sum[0];          // q=1 if sum even, else 0
endmodule