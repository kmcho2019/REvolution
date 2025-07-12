module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire [2:0] sum;
    assign sum = a + b + c + d;
    assign q = ~sum[0]; // LSB=0 means even count

endmodule