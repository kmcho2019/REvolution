module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Early zero-division check
    wire zero_divisor = (B == 8'b0);
    
    // Intermediate remainders (8-bit + 1 borrow bit)
    wire [8:0] rem [0:15];
    
    // First stage (MSB)
    assign rem[15] = zero_divisor ? 9'b0 : {1'b0, A[15]};
    assign result[15] = zero_divisor ? 1'b0 : (rem[15] >= {1'b0, B});
    
    // Generate remaining stages with optimized logic
    genvar i;
    generate
        for (i = 14; i >= 0; i = i - 1) begin : div_stages
            // Current remainder is previous remainder shifted left + current bit
            wire [8:0] current_in = zero_divisor ? 9'b0 : {rem[i+1][7:0], A[i]};
            
            // Optimized borrow-bit comparison and subtraction
            wire [8:0] diff = current_in - {1'b0, B};
            wire borrow = diff[8];
            assign result[i] = zero_divisor ? 1'b0 : ~borrow;
            assign rem[i] = zero_divisor ? 9'b0 : (borrow ? current_in : diff);
        end
    endgenerate
    
    // Final remainder output with proper zero-extension
    assign odd = zero_divisor ? 16'b0 : {8'b0, rem[0][7:0]};

endmodule