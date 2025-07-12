module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire [1:0] sum_ab, sum_cd;
    wire [2:0] total_sum;
    
    // First level: count 1's in a,b and c,d separately
    assign sum_ab = a + b;
    assign sum_cd = c + d;
    
    // Second level: sum the partial counts
    assign total_sum = sum_ab + sum_cd;
    
    // Output is 1 when total 1's is even (LSB of sum is 0)
    assign q = ~total_sum[0];
endmodule