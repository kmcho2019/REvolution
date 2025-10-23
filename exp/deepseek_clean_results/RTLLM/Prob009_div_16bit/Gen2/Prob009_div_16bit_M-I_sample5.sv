module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Handle division by zero case (result = all 1's, remainder = dividend)
    wire div_by_zero = (B == 8'b0);
    
    // Zero-extended divisor for comparison
    wire [15:0] b_ext = {8'b0, B};
    
    // Intermediate results
    wire [15:0] rem [0:16];  // One extra stage for initialization
    wire [15:0] quo [0:16];
    
    // Initialize first stage with dividend
    assign rem[16] = 16'b0;
    assign quo[16] = 16'b0;
    
    // Generate 16 stages of division (one per bit)
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_stages
            // Current remainder is previous remainder shifted left with current dividend bit
            wire [15:0] rem_shifted = {rem[i+1][14:0], A[i]};
            
            // Determine quotient bit and new remainder
            assign quo[i] = div_by_zero ? 16'hFFFF : 
                          (rem_shifted >= b_ext) ? 
                          (quo[i+1] | (16'b1 << i)) : 
                          quo[i+1];
                          
            assign rem[i] = div_by_zero ? A : 
                           (rem_shifted >= b_ext) ? 
                           (rem_shifted - b_ext) : 
                           rem_shifted;
        end
    endgenerate
    
    // Final outputs
    assign result = quo[0];
    assign odd = rem[0];

endmodule