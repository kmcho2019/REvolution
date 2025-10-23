module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline control
    reg [1:0] stage;
    
    // Input registers
    reg [31:0] a_reg, b_reg;
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_man, b_man;
    
    // Special case detection
    wire a_is_nan = &a[30:23] && |a[22:0];
    wire b_is_nan = &b[30:23] && |b[22:0];
    wire a_is_inf = &a[30:23] && ~|a[22:0];
    wire b_is_inf = &b[30:23] && ~|b[22:0];
    wire a_is_zero = ~|a[30:23] && ~|a[22:0];
    wire b_is_zero = ~|b[30:23] && ~|b[22:0];
    wire any_nan = a_is_nan || b_is_nan;
    wire inf_times_zero = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);
    
    // Pipeline registers
    reg [7:0] z_exp_pre;
    reg z_sign_pre;
    reg [47:0] product;
    reg overflow_detect;
    reg underflow_detect;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
            a_reg <= 0;
            b_reg <= 0;
            a_sign <= 0;
            b_sign <= 0;
            a_exp <= 0;
            b_exp <= 0;
            a_man <= 0;
            b_man <= 0;
            z_exp_pre <= 0;
            z_sign_pre <= 0;
            product <= 0;
            overflow_detect <= 0;
            underflow_detect <= 0;
        end else begin
            case (stage)
                0: begin // Stage 0: Input processing and special cases
                    a_reg <= a;
                    b_reg <= b;
                    
                    // Handle special cases with priority to NaN
                    if (any_nan) begin
                        z <= {1'b0, 8'hFF, 23'h400000}; // qNaN
                        stage <= 0;
                    end else if (inf_times_zero) begin
                        z <= {1'b0, 8'hFF, 23'h400000}; // qNaN
                        stage <= 0;
                    end else if (a_is_inf || b_is_inf) begin
                        z <= {a[31] ^ b[31], 8'hFF, 23'h0}; // Inf
                        stage <= 0;
                    end else if (a_is_zero || b_is_zero) begin
                        z <= {a[31] ^ b[31], 31'h0}; // Zero
                        stage <= 0;
                    end else begin
                        // Extract components
                        a_sign <= a[31];
                        b_sign <= b[31];
                        a_exp <= a[30:23];
                        b_exp <= b[30:23];
                        a_man <= |a[30:23] ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                        b_man <= |b[30:23] ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                        
                        // Calculate exponent with bias adjustment
                        z_exp_pre <= a_exp + b_exp - 8'd127;
                        // Detect potential overflow/underflow
                        overflow_detect <= (a_exp + b_exp > 9'd381); // 254 + 127 + bias
                        underflow_detect <= (a_exp + b_exp < 9'd127); // Check if exponent would be < 0
                        z_sign_pre <= a_sign ^ b_sign;
                        stage <= 1;
                    end
                end
                
                1: begin // Stage 1: Multiplication
                    // Calculate exact product (48-bit result)
                    product <= a_man * b_man;
                    stage <= 2;
                end
                
                2: begin // Stage 2: Normalization and rounding
                    reg [47:0] normalized_product;
                    reg [7:0] final_exp;
                    reg guard, round, sticky;
                    reg round_up;
                    
                    // Normalize product
                    if (product[47]) begin
                        normalized_product = product >> 1;
                        final_exp = z_exp_pre + 1;
                    end else begin
                        normalized_product = product;
                        final_exp = z_exp_pre;
                    end
                    
                    // Extract rounding bits
                    guard = normalized_product[22];
                    round = normalized_product[21];
                    sticky = |normalized_product[20:0];
                    
                    // Round to nearest even (IEEE-754 compliant)
                    round_up = guard && (round || sticky || normalized_product[23]);
                    
                    // Apply rounding if needed
                    if (round_up) begin
                        normalized_product[47:23] = normalized_product[47:23] + 1;
                        // Check for carry after rounding
                        if (normalized_product[47]) begin
                            normalized_product = normalized_product >> 1;
                            final_exp = final_exp + 1;
                        end
                    end
                    
                    // Handle overflow/underflow
                    if (overflow_detect || final_exp > 8'd254) begin
                        z <= {z_sign_pre, 8'hFF, 23'h0}; // Infinity
                    end else if (underflow_detect || final_exp == 0) begin
                        z <= {z_sign_pre, 31'h0}; // Zero (or denormal)
                    end else begin
                        z <= {z_sign_pre, final_exp, normalized_product[46:24]};
                    end
                    stage <= 0;
                end
            endcase
        end
    end

endmodule