module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Intermediate wires for remainder chain
    wire [8:0] remainder [0:16];
    
    // Initialize first remainder
    assign remainder[16] = 9'b0;
    
    // Generate division stages
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_stages
            // Current remainder with next dividend bit
            wire [8:0] current_remainder = {remainder[i+1][7:0], A[i]};
            
            // Comparison and subtraction logic
            assign result[i] = (current_remainder >= B);
            assign remainder[i] = result[i] ? (current_remainder - B) : current_remainder;
        end
    endgenerate

    // Final remainder output (16 bits, upper 8 bits zero)
    assign odd = {8'b0, remainder[0][7:0]};

endmodule