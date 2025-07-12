module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Special case detection (combinational)
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    wire a_zero = (a_exp == 0) && (a_frac == 0);
    wire b_zero = (b_exp == 0) && (b_frac == 0);
    wire a_inf = (a_exp == 8'hFF) && (a_frac == 0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 0);
    wire a_nan = (a_exp == 8'hFF) && (a_frac != 0);
    wire b_nan = (b_exp == 8'hFF) && (a_frac != 0);
    
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;
    wire [31:0] special_result;
    assign special_result = (a_nan | b_nan | (a_inf & b_zero) | (a_zero & b_inf)) ? 
                          {1'b0, 8'hFF, 1'b1, 22'b0} : // NaN
                          (a_inf | b_inf) ? {a_sign ^ b_sign, 8'hFF, 23'b0} : // Inf
                          {a_sign ^ b_sign, 31'b0}; // Zero

    // Pipeline registers
    reg [1:0] stage;
    reg [15:0] a_upper, b_upper;
    reg [7:0] a_lower, b_lower;
    reg [8:0] exp_sum; // Extra bit for overflow detection
    reg sign_reg;
    reg special_case_reg;

    // Shared multiplier (time-multiplexed)
    reg [15:0] mult_a, mult_b;
    wire [23:0] mult_result = mult_a * mult_b;
    
    // Partial products (smaller representation)
    reg [23:0] pp_uu; // Upper x Upper (16x16 -> 32 bits, but we only need 24)
    reg [15:0] pp_ul; // Upper x Lower (16x8 -> 24 bits, but we only need 16)
    reg [15:0] pp_lu; // Lower x Upper (8x16 -> 24 bits, but we only need 16)
    reg [7:0]  pp_ll; // Lower x Lower (8x8 -> 16 bits, but we only need 8)

    // Product accumulation (carry-save form)
    reg [23:0] sum;
    reg [23:0] carry;

    // Normalization and rounding
    reg [22:0] final_mantissa;
    reg [7:0] final_exponent;
    reg final_sign;

    // Clock gating signals
    wire normal_path_enable = ~special_case_reg & ~rst;
    wire [1:0] next_stage = normal_path_enable ? stage + 1 : 0;

    always @(posedge clk) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
            special_case_reg <= 0;
        end else begin
            special_case_reg <= special_case;
            
            if (special_case) begin
                z <= special_result;
                stage <= 0;
            end else begin
                case (stage)
                    0: begin // Stage 1: Input preparation
                        a_upper <= (a_exp == 0) ? {1'b0, a_frac[22:8]} : {1'b1, a_frac[22:8]};
                        b_upper <= (b_exp == 0) ? {1'b0, b_frac[22:8]} : {1'b1, b_frac[22:8]};
                        a_lower <= a_frac[7:0];
                        b_lower <= b_frac[7:0];
                        exp_sum <= a_exp + b_exp - 127; // Precompute biased sum
                        sign_reg <= a_sign ^ b_sign;
                        stage <= next_stage;
                    end
                    
                    1: begin // Stage 2: Partial multiplications (time-multiplexed)
                        // Compute pp_uu
                        mult_a <= a_upper;
                        mult_b <= b_upper;
                        pp_uu <= mult_result[23:0];
                        
                        // Compute pp_ul and pp_lu in next cycle
                        stage <= next_stage;
                    end
                    
                    2: begin // Stage 3: Continue partial multiplications
                        // Compute pp_ul
                        mult_a <= a_upper;
                        mult_b <= {8'b0, b_lower};
                        pp_ul <= mult_result[15:0];
                        
                        // Compute pp_lu
                        mult_a <= {8'b0, a_lower};
                        mult_b <= b_upper;
                        pp_lu <= mult_result[15:0];
                        
                        // Compute pp_ll in next cycle
                        stage <= next_stage;
                    end
                    
                    3: begin // Stage 4: Final partial product and start accumulation
                        // Compute pp_ll
                        mult_a <= {8'b0, a_lower};
                        mult_b <= {8'b0, b_lower};
                        pp_ll <= mult_result[7:0];
                        
                        // Initialize carry-save adder
                        sum <= {pp_uu, 8'b0}; // pp_uu << 8
                        carry <= {8'b0, pp_ul, 8'b0} + {8'b0, pp_lu, 8'b0};
                        stage <= next_stage;
                    end
                    
                    4: begin // Stage 5: Complete accumulation
                        // Final addition with pp_ll
                        {carry, sum} <= sum + carry + {16'b0, pp_ll};
                        stage <= next_stage;
                    end
                    
                    5: begin // Stage 6: Normalization and rounding
                        if (sum[23]) begin
                            final_mantissa <= sum[22:0] + (sum[0] & (|carry[22:0]));
                            final_exponent <= exp_sum[7:0] + 1;
                        end else begin
                            final_mantissa <= sum[21:0] + (carry[22] & (|carry[21:0]));
                            final_exponent <= exp_sum[7:0];
                        end
                        final_sign <= sign_reg;
                        stage <= next_stage;
                    end
                    
                    6: begin // Stage 7: Output formatting
                        if (exp_sum[8] | (final_exponent == 0)) begin // Underflow
                            z <= {final_sign, 31'b0};
                        end else if (&final_exponent) begin // Overflow
                            z <= {final_sign, 8'hFF, 23'b0};
                        end else begin
                            z <= {final_sign, final_exponent, final_mantissa};
                        end
                        stage <= 0;
                    end
                endcase
            end
        end
    end

endmodule