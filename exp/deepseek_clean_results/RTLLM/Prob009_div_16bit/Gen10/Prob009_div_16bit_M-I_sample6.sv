module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Early termination for zero divisor
    wire zero_divisor = (B == 8'b0);
    
    // Main division logic
    wire [8:0] step_in [0:15];
    wire [7:0] rem_out [0:15];
    wire [15:0] quotient_bits;
    
    // Initial step
    assign step_in[0] = {1'b0, A[15]};
    assign rem_out[0] = (zero_divisor) ? 8'b0 : 
                      ((step_in[0] >= {1'b0, B}) ? (step_in[0] - B) : step_in[0][7:0]);
    assign quotient_bits[15] = (zero_divisor) ? 1'b0 : (step_in[0] >= {1'b0, B});
    
    // Optimized division steps
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : div_steps
            // Shared comparator and subtractor
            wire [8:0] current_step = {rem_out[i-1], A[15-i]};
            wire step_ge = (zero_divisor) ? 1'b0 : (current_step >= {1'b0, B});
            wire [7:0] step_diff = (zero_divisor) ? 8'b0 : (current_step - B);
            
            assign rem_out[i] = step_ge ? step_diff : current_step[7:0];
            assign quotient_bits[15-i] = step_ge;
            assign step_in[i] = current_step; // For debugging if needed
        end
    endgenerate
    
    // Output assignments
    assign result = quotient_bits;
    assign odd = (zero_divisor) ? A[7:0] : rem_out[15];

endmodule