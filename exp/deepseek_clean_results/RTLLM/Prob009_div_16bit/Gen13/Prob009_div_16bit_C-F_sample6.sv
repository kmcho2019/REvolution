module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd  // Reduced to 8-bit since divisor is 8-bit
);

    wire [8:0] current_remainder [0:15];  // 9-bit remainders (8 + carry)
    wire [7:0] final_remainder;           // Final 8-bit remainder

    // Initialize first remainder with MSB of dividend
    assign current_remainder[15] = {1'b0, A[15]};
    assign result[15] = (current_remainder[15] >= {1'b0, B});

    // Division logic for each bit using generate
    genvar i;
    generate
        for (i = 15; i > 0; i = i - 1) begin : div_loop
            wire [8:0] next_remainder;
            
            // Calculate next remainder: subtract if possible, then shift in next bit
            assign next_remainder = (current_remainder[i] >= {1'b0, B}) ? 
                                   (current_remainder[i] - {1'b0, B}) : 
                                   current_remainder[i];
            
            // Shift remainder left and bring in next dividend bit
            assign current_remainder[i-1] = {next_remainder[7:0], A[i-1]};
            
            // Set quotient bit
            assign result[i-1] = (current_remainder[i] >= {1'b0, B});
        end
    endgenerate

    // Final remainder calculation
    assign final_remainder = (current_remainder[0] >= {1'b0, B}) ? 
                            (current_remainder[0] - {1'b0, B}) : 
                            current_remainder[0][7:0];
    
    // Outputs
    assign odd = final_remainder;  // 8-bit remainder

endmodule