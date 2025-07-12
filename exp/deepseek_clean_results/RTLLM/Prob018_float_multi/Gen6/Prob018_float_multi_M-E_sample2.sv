module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Special case detection (combinatorial)
    wire a_is_nan = &a[30:23] && |a[22:0];
    wire b_is_nan = &b[30:23] && |b[22:0];
    wire a_is_inf = &a[30:23] && ~|a[22:0];
    wire b_is_inf = &b[30:23] && ~|b[22:0];
    wire a_is_zero = ~|a[30:23] && ~|a[22:0];
    wire b_is_zero = ~|b[30:23] && ~|b[22:0];
    wire any_nan = a_is_nan || b_is_nan;
    wire inf_times_zero = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);

    // Immediate special case resolution
    wire [31:0] special_case_z = 
        any_nan ? {1'b0, 8'hFF, 23'h400000} : // qNaN
        inf_times_zero ? {1'b0, 8'hFF, 23'h400000} : // qNaN
        a_is_inf || b_is_inf ? {a[31] ^ b[31], 8'hFF, 23'h0} : // Inf
        a_is_zero || b_is_zero ? {a[31] ^ b[31], 31'h0} : // Zero
        32'h0;

    // Normal processing pipeline
    reg [1:0] stage;
    reg [31:0] a_reg, b_reg;
    reg special_case;
    
    // Normalized components
    reg [23:0] a_man, b_man;
    reg [7:0] a_exp, b_exp;
    reg a_sign, b_sign;
    
    // Multiplication results
    reg [47:0] product;
    reg [7:0] exp_sum;
    reg result_sign;
    
    // Speculative rounding results
    reg [47:0] rounded_up, rounded_down;
    reg [7:0] exp_up, exp_down;
    
    // Final selection
    reg guard, round, sticky;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
            special_case <= 0;
        end else begin
            case (stage)
                0: begin // Stage 0: Input processing
                    a_reg <= a;
                    b_reg <= b;
                    
                    if (any_nan || inf_times_zero || a_is_inf || b_is_inf || a_is_zero || b_is_zero) begin
                        special_case <= 1;
                        z <= special_case_z;
                        stage <= 0;
                    end else begin
                        special_case <= 0;
                        
                        // Extract and normalize mantissas
                        a_man <= |a[30:23] ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                        b_man <= |b[30:23] ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                        
                        // Store other components
                        a_exp <= a[30:23];
                        b_exp <= b[30:23];
                        a_sign <= a[31];
                        b_sign <= b[31];
                        
                        // Pre-compute exponent sum
                        exp_sum <= a_exp + b_exp - 8'd127;
                        result_sign <= a_sign ^ b_sign;
                        
                        stage <= 1;
                    end
                end
                
                1: begin // Stage 1: Multiplication and speculative rounding
                    // Perform multiplication
                    product <= a_man * b_man;
                    
                    // Calculate both possible rounded results
                    rounded_up <= (product + (1 << 22)) >> 23;
                    rounded_down <= product >> 23;
                    
                    // Calculate both possible exponents
                    exp_up <= exp_sum + 1;
                    exp_down <= exp_sum;
                    
                    stage <= 2;
                end
                
                2: begin // Stage 2: Rounding selection and final assembly
                    // Determine rounding bits
                    guard = product[22];
                    round = product[21];
                    sticky = |product[20:0];
                    
                    // Select correct rounded result
                    if (guard && (round || sticky)) begin
                        if (rounded_up[24]) begin // Check for carry
                            z <= {result_sign, exp_up + 1, rounded_up[23:1]};
                        end else begin
                            z <= {result_sign, exp_up, rounded_up[22:0]};
                        end
                    end else begin
                        if (rounded_down[23]) begin // Check for carry
                            z <= {result_sign, exp_down + 1, rounded_down[22:0]};
                        end else begin
                            z <= {result_sign, exp_down, rounded_down[22:0]};
                        end
                    end
                    
                    // Handle overflow/underflow
                    if (exp_sum > 8'd254) begin // Overflow
                        z <= {result_sign, 8'hFF, 23'h0};
                    end else if (exp_sum == 0) begin // Underflow
                        z <= {result_sign, 31'h0};
                    end
                    
                    stage <= 0;
                end
            endcase
        end
    end

endmodule