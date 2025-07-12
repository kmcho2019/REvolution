module TopModule(
    input  [7:0] a,     // 8-bit input
    input  [7:0] b,     // 8-bit input
    output [7:0] s,     // 8-bit output
    output overflow    // overflow indicator
);

    // Perform 9-bit addition to check for overflow
    wire [8:0] temp_sum = {a[7], a} + {b[7], b};
    
    // Assign the result (excluding the MSB) to output s
    assign s = temp_sum[7:0];
    
    // Check if the MSB of the result is 1 (indicating overflow)
    assign overflow = temp_sum[8];

endmodule