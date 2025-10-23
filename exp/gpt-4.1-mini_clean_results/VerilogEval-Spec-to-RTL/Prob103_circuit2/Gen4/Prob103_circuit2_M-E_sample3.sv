module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire [2:0] sum;
    assign sum = a + b + c + d;
    assign q = ~(sum[0]); // q=1 if number of ones is even (sum LSB=0), else q=0

endmodule