module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Intermediate wires for remainder propagation
    wire [8:0] remainder [0:16];  // 9-bit remainders (8+1 for comparison)
    
    // Initialize first remainder to 0
    assign remainder[0] = 9'b0;
    
    // Generate 16 processing stages
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_stage
            // Current remainder is previous remainder shifted left + current bit
            wire [8:0] current_in = {remainder[15-i][7:0], A[i]};
            
            // Comparison and subtraction logic
            assign result[i] = (current_in >= B);
            assign remainder[15-i+1] = result[i] ? (current_in - B) : current_in;
        end
    endgenerate
    
    // Final remainder output (8 bits)
    assign odd = remainder[16][7:0];

endmodule