module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire [2:0] sum;
    
    // Sum all input bits
    assign sum = a + b + c + d;
    
    // Output 1 if sum is even (LSB of sum is 0)
    assign q = ~sum[0];

endmodule