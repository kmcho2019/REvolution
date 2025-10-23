module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] extended_sum;
    
    // Perform 9-bit addition to capture the carry out
    assign extended_sum = {a[7], a} + {b[7], b};
    
    // The sum is the lower 8 bits
    assign s = extended_sum[7:0];
    
    // Overflow occurs when carry-in and carry-out of MSB differ
    assign overflow = extended_sum[8] ^ extended_sum[7];
endmodule