module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Early termination for zero divisor (top level gating)
    wire zero_divisor = (B == 8'b0);
    assign result = zero_divisor ? 16'b0 : quotient;
    assign odd = zero_divisor ? A[7:0] : remainder;
    
    // Main division logic (only active when B != 0)
    wire [15:0] quotient;
    wire [7:0] remainder;
    
    generate
        if (1) begin : div_logic
            // Shared resources
            wire [8:0] cmp_mask = {1'b0, B};
            wire [8:0] initial_step = {1'b0, A[15]};
            
            // First stage
            wire [7:0] rem0;
            wire q_bit15;
            assign q_bit15 = (initial_step >= cmp_mask);
            assign rem0 = q_bit15 ? (initial_step - cmp_mask) : initial_step[7:0];
            
            // Pipeline remainder through stages
            wire [7:0] rem [0:15];
            assign rem[0] = rem0;
            
            // Generate optimized stages
            genvar i;
            for (i = 1; i < 16; i = i + 1) begin : div_stages
                // Carry-save style calculation
                wire [8:0] current = {rem[i-1], A[15-i]};
                wire q_bit = (current >= cmp_mask);
                assign rem[i] = q_bit ? (current - cmp_mask) : current[7:0];
                assign quotient[15-i] = q_bit;
            end
            
            // Final assignments
            assign quotient[15] = q_bit15;
            assign remainder = rem[15];
        end
    endgenerate

endmodule