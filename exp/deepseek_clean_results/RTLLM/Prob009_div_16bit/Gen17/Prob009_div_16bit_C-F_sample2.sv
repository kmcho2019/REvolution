module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Intermediate wires for remainder propagation
    wire [8:0] rem [0:15];  // 9-bit remainders (8+1 for comparison)
    
    // First stage (MSB)
    assign rem[15] = {1'b0, A[15]};
    assign result[15] = (rem[15] >= {1'b0, B});
    
    // Generate remaining stages with optimized logic
    genvar i;
    generate
        for (i = 14; i >= 0; i = i - 1) begin : div_stages
            // Current remainder is previous remainder shifted left + current bit
            wire [8:0] current_in = {rem[i+1][7:0], A[i]};
            
            // Optimized comparison and subtraction logic
            wire [8:0] diff = current_in - {1'b0, B};
            assign result[i] = ~diff[8];  // MSB indicates borrow (current_in < B)
            assign rem[i] = result[i] ? diff : current_in;
        end
    endgenerate
    
    // Final remainder output with zero-division check and proper zero-extension
    assign odd = (B == 8'b0) ? 16'b0 : {8'b0, rem[0][7:0]};

endmodule