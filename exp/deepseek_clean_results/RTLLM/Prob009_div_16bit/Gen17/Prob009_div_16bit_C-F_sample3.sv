module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Early zero-division check
    wire zero_divisor = (B == 8'b0);
    
    // Temporary remainder storage (9 bits: 8 for remainder + 1 for comparison)
    wire [8:0] temp_remainder [0:15];
    
    // Initialize first stage
    assign temp_remainder[15] = zero_divisor ? 9'b0 : {1'b0, A[15]};
    assign result[15] = zero_divisor ? 1'b0 : (temp_remainder[15] >= {1'b0, B});
    
    // Generate remaining stages
    genvar i;
    generate
        for (i = 14; i >= 0; i = i - 1) begin : div_stages
            // Current remainder is previous remainder shifted left + current bit
            wire [8:0] current_in = zero_divisor ? 9'b0 : {temp_remainder[i+1][7:0], A[i]};
            
            // Optimized comparison and subtraction logic
            wire [8:0] diff = current_in - {1'b0, B};
            assign result[i] = zero_divisor ? 1'b0 : ~diff[8];  // MSB indicates borrow
            assign temp_remainder[i] = zero_divisor ? 9'b0 : (result[i] ? diff : current_in);
        end
    endgenerate
    
    // Final remainder output (zero-extended to 16 bits)
    assign odd = zero_divisor ? 16'b0 : {8'b0, temp_remainder[0][7:0]};

endmodule