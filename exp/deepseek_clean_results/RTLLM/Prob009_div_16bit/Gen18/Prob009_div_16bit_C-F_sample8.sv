module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Early zero-divisor detection
    wire zero_divisor = (B == 8'b0);
    
    // Remainder chain with carry-save technique
    wire [8:0] remainder [0:16];  // [carry, remainder]
    assign remainder[16] = 9'b0;
    
    // Generate division logic
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_loop
            // Shift remainder and add next bit (carry-save)
            wire [8:0] shifted_remainder = {remainder[i+1][7:0], A[i]};
            
            // Optimized 8-bit comparison
            wire do_subtract = (shifted_remainder >= {1'b0, B});
            
            // Conditional subtraction
            wire [8:0] new_remainder = do_subtract ? 
                (shifted_remainder - {1'b0, B}) : shifted_remainder;
            
            // Handle zero divisor case
            assign remainder[i] = zero_divisor ? 9'b0 : new_remainder;
            assign result[i] = zero_divisor ? 1'b0 : do_subtract;
        end
    endgenerate

    // Final remainder output (16-bit as specified)
    assign odd = zero_divisor ? 16'b0 : {8'b0, remainder[0][7:0]};

endmodule