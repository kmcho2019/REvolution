module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire [2:0] sum;  // Enough bits to hold sum of 4 1-bit inputs
    
    // Sum all inputs
    assign sum = a + b + c + d;
    
    // Output 1 if sum is even (LSB is 0)
    assign q = ~sum[0];

endmodule