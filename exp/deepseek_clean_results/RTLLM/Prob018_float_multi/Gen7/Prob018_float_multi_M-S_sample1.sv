module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg stage;
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exp, b_exp, z_exp;
    reg [23:0] a_man, b_man;
    reg [47:0] product;
    reg [7:0] exp_sum;
    reg result_nan, result_inf, result_zero;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
        end else begin
            case (stage)
                0: begin // Stage 1: Input processing and multiplication
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    
                    // Handle denormals and prepare mantissas
                    a_man <= (a_exp == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_man <= (b_exp == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                    
                    // Special case detection
                    result_nan <= ((a_exp == 8'hFF && a[22:0] != 0) || 
                                  (b_exp == 8'hFF && b[22:0] != 0) ||
                                  ((a_exp == 8'hFF) && (b_exp == 0) && (b[22:0] == 0)) ||
                                  ((b_exp == 8'hFF) && (a_exp == 0) && (a[22:0] == 0));
                    
                    result_inf <= ((a_exp == 8'hFF && a[22:0] == 0) || 
                                 (b_exp == 8'hFF && b[22:0] == 0)) && !result_nan;
                    
                    result_zero <= ((a_exp == 0 && a[22:0] == 0) || 
                                   (b_exp == 0 && b[22:0] == 0)) && !result_nan;
                    
                    // Multiply mantissas
                    product <= a_man * b_man;
                    
                    // Calculate exponent sum
                    exp_sum <= a_exp + b_exp - 127;
                    
                    stage <= 1;
                end
                
                1: begin // Stage 2: Normalization and output
                    // Normalize product
                    if (product[47]) begin
                        z_exp <= exp_sum + 1;
                        z_man <= product[46:24] + (product[23] & (product[22] | |product[21:0]));
                    end else begin
                        z_exp <= exp_sum;
                        z_man <= product[45:23] + (product[22] & (product[21] | |product[20:0]));
                    end
                    
                    // Handle overflow/underflow
                    if (z_exp[7] && z_exp != 8'hFF) begin // Underflow
                        z_exp <= 0;
                        z_man <= 0;
                    end else if (&z_exp[7:6]) begin // Overflow
                        z_exp <= 8'hFF;
                        z_man <= 0;
                    end
                    
                    // Set sign
                    z_sign <= a_sign ^ b_sign;
                    
                    // Final result assembly
                    if (result_nan) begin
                        z <= {1'b0, 8'hFF, 23'h7FFFFF}; // NaN
                    end else if (result_inf) begin
                        z <= {z_sign, 8'hFF, 23'h0}; // Infinity
                    end else if (result_zero) begin
                        z <= {z_sign, 8'h0, 23'h0}; // Zero
                    end else begin
                        z <= {z_sign, z_exp, z_man[22:0]};
                    end
                    
                    stage <= 0;
                end
            endcase
        end
    end

endmodule