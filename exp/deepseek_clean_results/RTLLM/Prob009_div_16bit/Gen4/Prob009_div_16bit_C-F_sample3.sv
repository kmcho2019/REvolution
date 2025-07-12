module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Handle division by zero case
    wire div_by_zero = (B == 8'b0);
    
    // Working registers (16-bit dividend + 8-bit remainder space)
    wire [23:0] rem [0:16];  // One extra stage for initialization
    wire [15:0] quo [0:16];
    
    // Initialize first stage with dividend (zero-extended to 24 bits)
    assign rem[16] = {8'b0, A};
    assign quo[16] = 16'b0;
    
    // Generate 16 stages of division (one per bit)
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_stages
            // Current remainder is previous remainder shifted left with current dividend bit
            wire [23:0] rem_shifted = {rem[i+1][22:0], 1'b0};
            
            // Perform subtraction (non-restoring algorithm)
            wire [8:0] diff = rem_shifted[23:16] - B;
            
            // Determine quotient bit and new remainder
            assign quo[i] = div_by_zero ? 16'hFFFF : 
                          (~diff[8]) ? 
                          (quo[i+1] | (16'b1 << i)) : 
                          quo[i+1];
                          
            assign rem[i] = div_by_zero ? {8'b0, A} : 
                           (~diff[8]) ? 
                           {diff[7:0], rem_shifted[15:0]} : 
                           rem_shifted;
        end
    endgenerate
    
    // Final outputs
    assign result = quo[0];
    assign odd = div_by_zero ? A[7:0] : rem[0][23:16];

endmodule