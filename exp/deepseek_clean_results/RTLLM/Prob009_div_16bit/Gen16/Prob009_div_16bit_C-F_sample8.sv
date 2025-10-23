module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Early zero-divisor check
    wire zero_divisor = (B == 8'b0);
    
    // Remainder propagation wires (9 bits to include carry)
    wire [8:0] rem [0:15];
    
    // Initialize first remainder with MSB of dividend
    assign rem[15] = {1'b0, A[15]};
    
    // Division logic for each bit
    genvar i;
    generate
        for (i = 15; i >= 0; i = i - 1) begin : div_loop
            // Current remainder concatenated with next dividend bit
            wire [8:0] current_rem = (i < 15) ? {rem[i+1][7:0], A[i]} : rem[i];
            
            // Comparison and subtraction
            wire do_subtract = ~zero_divisor & (current_rem >= {1'b0, B});
            assign rem[i] = do_subtract ? (current_rem - {1'b0, B}) : current_rem;
            assign result[i] = do_subtract;
        end
    endgenerate
    
    // Final remainder (only need lower 8 bits)
    assign odd = zero_divisor ? 8'b0 : rem[0][7:0];

endmodule