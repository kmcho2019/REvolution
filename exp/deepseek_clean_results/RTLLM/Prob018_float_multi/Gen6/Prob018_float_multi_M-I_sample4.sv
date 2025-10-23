module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    reg [2:0] counter;
    reg [31:0] a_reg, b_reg;
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exp, b_exp, z_exp;
    reg [23:0] a_man, b_man;
    reg [47:0] product;
    reg [9:0] exp_sum;
    reg guard_bit, round_bit, sticky;
    reg [22:0] z_man;

    // Special case flags
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;
    reg result_nan, result_inf, result_zero;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 0;
        end else begin
            case (counter)
                0: begin // Stage 1: Input processing
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    
                    // Handle denormals
                    a_man <= (a[30:23] == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_man <= (b[30:23] == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                    
                    // Special case detection
                    a_zero <= (a[30:0] == 0);
                    b_zero <= (b[30:0] == 0);
                    a_inf <= (a_exp == 8'hFF) & (a[22:0] == 0);
                    b_inf <= (b_exp == 8'hFF) & (b[22:0] == 0);
                    a_nan <= (a_exp == 8'hFF) & (a[22:0] != 0);
                    b_nan <= (b_exp == 8'hFF) & (b[22:0] != 0);
                    
                    counter <= 1;
                end
                
                1: begin // Stage 2: Multiplication
                    // Multiply mantissas
                    product <= a_man * b_man;
                    
                    // Calculate exponent sum
                    exp_sum <= {2'b0, a_exp} + {2'b0, b_exp} - 127;
                    
                    // Set sign
                    z_sign <= a_sign ^ b_sign;
                    
                    // Special case results
                    result_nan <= a_nan | b_nan | (a_zero & b_inf) | (a_inf & b_zero);
                    result_inf <= (a_inf | b_inf) & ~result_nan;
                    result_zero <= (a_zero | b_zero) & ~result_nan;
                    
                    counter <= 2;
                end
                
                2: begin // Stage 3: Normalization and rounding
                    // Normalize
                    if (product[47]) begin
                        z_man <= product[46:24];
                        z_exp <= exp_sum[7:0] + 1;
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky <= |product[21:0];
                    end else begin
                        z_man <= product[45:23];
                        z_exp <= exp_sum[7:0];
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky <= |product[20:0];
                    end
                    
                    // Rounding (round to nearest even)
                    if (guard_bit && (round_bit || sticky || z_man[0])) begin
                        {z_exp, z_man} <= {z_exp, z_man} + 1;
                    end
                    
                    // Handle overflow/underflow
                    if (z_exp[7] && !z_exp[8]) begin // Underflow
                        z_exp <= 0;
                        z_man <= 0;
                    end else if (z_exp[8:7] == 2'b01) begin // Overflow
                        z_exp <= 8'hFF;
                        z_man <= 0;
                    end
                    
                    // Final result assembly
                    if (result_nan) begin
                        z <= {1'b0, 8'hFF, 23'h7FFFFF}; // NaN
                    end else if (result_inf) begin
                        z <= {z_sign, 8'hFF, 23'h0}; // Infinity
                    end else if (result_zero) begin
                        z <= {z_sign, 31'h0}; // Zero
                    end else begin
                        z <= {z_sign, z_exp, z_man};
                    end
                    
                    counter <= 0;
                end
            endcase
        end
    end

endmodule