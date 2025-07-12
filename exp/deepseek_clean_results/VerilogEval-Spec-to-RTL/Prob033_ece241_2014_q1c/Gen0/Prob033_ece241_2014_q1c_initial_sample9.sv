module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [7:0] sum;
    assign sum = a + b;
    assign s = sum;
    
    // Overflow occurs when:
    // 1. Both inputs are positive and sum is negative, or
    // 2. Both inputs are negative and sum is positive
    assign overflow = (~a[7] & ~b[7] & sum[7]) |  // Case 1
                      (a[7] & b[7] & ~sum[7]);    // Case 2
endmodule