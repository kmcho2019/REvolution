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
    
    // Optimized logarithmic approximation
    function [7:0] log2_approx;
        input [23:0] x;
        begin
            case (x[23:21])
                3'b100: log2_approx = 8'd128 + x[20:13];
                3'b010: log2_approx = 8'd64 + x[19:12];
                3'b001: log2_approx = 8'd32 + x[18:11];
                default: log2_approx = x[7:0];
            endcase
        end
    endfunction
    
    function [23:0] antilog_approx;
        input [15:0] x; // 8.8 fixed point
        reg [7:0] int_part;
        reg [7:0] frac_part;
        begin
            int_part = x[15:8];
            frac_part = x[7:0];
            antilog_approx = (24'b1 << int_part) + ((24'b1 << int_part) * frac_part / 256);
        end
    endfunction
    
    // Pipeline registers
    reg [15:0] log_sum;
    reg [23:0] exact_low;
    reg [7:0] z_exp_pre;
    reg z_sign_pre;
    reg [47:0] exact_product;
    reg [23:0] z_man_corr;
    reg overflow_detect;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
        end else begin
            case (stage)
                0: begin // Stage 0: Input processing and special cases
                    a_reg <= a;
                    b_reg <= b;
                    
                    if (any_nan) begin
                        z <= {1'b0, 8'hFF, 23'h400000}; // qNaN
                    end else if (inf_times_zero) begin
                        z <= {1'b0, 8'hFF, 23'h400000}; // qNaN
                    end else if (a_is_inf || b_is_inf) begin
                        z <= {a[31] ^ b[31], 8'hFF, 23'h0}; // Inf
                    end else if (a_is_zero || b_is_zero) begin
                        z <= {a[31] ^ b[31], 31'h0}; // Zero
                    end else begin
                        // Extract components
                        a_sign <= a[31];
                        b_sign <= b[31];
                        a_exp <= a[30:23];
                        b_exp <= b[30:23];
                        a_man <= |a[30:23] ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                        b_man <= |b[30:23] ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                        
                        // Pre-calculate exponent with overflow detection
                        z_exp_pre <= a_exp + b_exp - 8'd127;
                        overflow_detect <= (a_exp > 8'd127 && b_exp > 8'd127) || 
                                         (a_exp + b_exp < 8'd127);
                        z_sign_pre <= a_sign ^ b_sign;
                        stage <= 1;
                    end
                end
                
                1: begin // Stage 1: Logarithmic approximation and exact product
                    // Calculate log approximations
                    log_sum <= {8'b0, log2_approx(a_man)} + {8'b0, log2_approx(b_man)};
                    
                    // Calculate exact product (shared multiplier)
                    exact_product <= a_man * b_man;
                    exact_low <= a_man[15:0] * b_man[15:0]; // More bits for better correction
                    stage <= 2;
                end
                
                2: begin // Stage 2: Antilog, correction, and normalization
                    // Get approximate product
                    reg [23:0] approx_product = antilog_approx(log_sum);
                    
                    // Calculate correction factor from exact low bits
                    reg [23:0] correction = exact_low >> 16;
                    
                    // Combine with exact product
                    reg [47:0] product = exact_product;
                    reg [7:0] exponent = z_exp_pre;
                    
                    // Apply correction
                    product[23:0] = product[23:0] + correction;
                    
                    // Normalize
                    if (product[47]) begin
                        product = product >> 1;
                        exponent = exponent + 1;
                    end
                    
                    // Round to nearest even
                    reg sticky = |product[22:0];
                    if (product[23] && (product[22] || sticky)) begin
                        product[47:24] = product[47:24] + 1;
                        if (product[47]) begin
                            product = product >> 1;
                            exponent = exponent + 1;
                        end
                    end
                    
                    // Handle overflow/underflow
                    if (overflow_detect || exponent[7] || (&exponent)) begin
                        z <= (exponent[7] || overflow_detect) ? 
                             {z_sign_pre, 31'h0} : {z_sign_pre, 8'hFF, 23'h0};
                    end else begin
                        z <= {z_sign_pre, exponent, product[46:24]};
                    end
                    stage <= 0;
                end
            endcase
        end
    end

endmodule