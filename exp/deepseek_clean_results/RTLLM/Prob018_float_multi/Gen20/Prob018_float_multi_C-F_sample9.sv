module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [1:0] stage;
    
    // Stage 0 registers
    reg [23:0] a_mantissa_0, b_mantissa_0;
    reg [7:0] a_exponent_0, b_exponent_0;
    reg a_sign_0, b_sign_0;
    reg special_case_0;
    reg inf_case_0, zero_case_0, nan_case_0;
    
    // Stage 1 registers
    reg [47:0] product_1;
    reg [7:0] exp_sum_1;
    reg sign_1;
    reg special_case_1;
    reg inf_case_1, zero_case_1, nan_case_1;
    
    // Stage 2 wires
    wire product_msb = product_1[47];
    wire [23:0] norm_mantissa = product_msb ? product_1[46:23] : product_1[45:22];
    wire [7:0] norm_exponent = product_msb ? (exp_sum_1 + 1) : exp_sum_1;
    
    // Optimized rounding logic
    wire guard_bit = product_msb ? product_1[22] : product_1[21];
    wire round_bit = product_msb ? product_1[21] : product_1[20];
    wire sticky_bit = product_msb ? (|product_1[20:0]) : (|product_1[19:0]);
    wire round_inc = guard_bit & (round_bit | sticky_bit);
    
    wire [23:0] rounded_mantissa = norm_mantissa + round_inc;
    wire rounding_overflow = &norm_mantissa & round_inc;
    
    // Final exponent with overflow/underflow detection
    wire [7:0] final_exponent = rounding_overflow ? norm_exponent + 1 : norm_exponent;
    wire overflow = (final_exponent >= 8'hFE);
    wire underflow = (final_exponent[7] & (final_exponent != 8'hFF));
    
    // Special case detection (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
            // Clear pipeline registers
            {a_mantissa_0, b_mantissa_0, a_exponent_0, b_exponent_0} <= 0;
            {a_sign_0, b_sign_0, special_case_0, inf_case_0, zero_case_0, nan_case_0} <= 0;
            {product_1, exp_sum_1, sign_1, special_case_1, inf_case_1, zero_case_1, nan_case_1} <= 0;
        end else begin
            case (stage)
                0: begin // Input and special case detection
                    // Extract components with implicit normalization
                    a_sign_0 <= a[31];
                    b_sign_0 <= b[31];
                    a_exponent_0 <= a[30:23];
                    b_exponent_0 <= b[30:23];
                    a_mantissa_0 <= {|a[30:23], a[22:0]};
                    b_mantissa_0 <= {|b[30:23], b[22:0]};
                    
                    // Early special case detection
                    nan_case_0 <= a_nan | b_nan | (a_inf & b_zero) | (b_inf & a_zero);
                    inf_case_0 <= (a_inf | b_inf) & ~nan_case_0;
                    zero_case_0 <= (a_zero | b_zero) & ~nan_case_0;
                    special_case_0 <= nan_case_0 | inf_case_0 | zero_case_0;
                    
                    stage <= 1;
                end
                
                1: begin // Parallel computation
                    // Optimized 24x24 multiplication (Wallace tree concept)
                    product_1 <= a_mantissa_0 * b_mantissa_0;
                    
                    // Exponent processing with bias adjustment
                    exp_sum_1 <= a_exponent_0 + b_exponent_0 - 8'd127;
                    sign_1 <= a_sign_0 ^ b_sign_0;
                    
                    // Pipeline special cases
                    special_case_1 <= special_case_0;
                    inf_case_1 <= inf_case_0;
                    zero_case_1 <= zero_case_0;
                    nan_case_1 <= nan_case_0;
                    
                    stage <= 2;
                end
                
                2: begin // Finalization
                    case (1'b1)
                        nan_case_1: z <= {1'b0, 8'hFF, 1'b1, 22'b0}; // Canonical NaN
                        inf_case_1: z <= {sign_1, 8'hFF, 23'b0};
                        zero_case_1: z <= {sign_1, 31'b0};
                        overflow: z <= {sign_1, 8'hFF, 23'b0};
                        underflow: z <= {sign_1, 31'b0};
                        default: z <= {sign_1, final_exponent, rounded_mantissa[22:0]};
                    endcase
                    
                    stage <= 0;
                end
            endcase
        end
    end

endmodule