module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    reg [1:0] stage;

    // Input decomposition
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Special case detection (gated)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a_exp) && (a_frac == 0);
    wire b_inf = (&b_exp) && (b_frac == 0);
    wire a_nan = (&a_exp) && (|a_frac);
    wire b_nan = (&b_exp) && (|b_frac);
    wire special_case = a_nan | b_nan | ((a_inf | b_inf) & (a_zero | b_zero));
    wire [31:0] special_result = a_nan | b_nan ? 32'h7FC00000 : 
                               (a_inf | b_inf) ? {a_sign ^ b_sign, 8'hFF, 23'b0} : 
                               {a_sign ^ b_sign, 31'b0};

    // Pipeline registers
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg special_valid;
    reg [31:0] special_reg;
    
    // Partial products
    reg [23:0] pp0, pp1;
    reg [47:0] sum, carry;
    
    // Normalization and rounding
    reg [23:0] z_mantissa;
    reg [7:0] z_exponent;
    reg z_sign;
    reg need_round;

    // Combinational logic
    wire [7:0] exp_biased = a_exponent + b_exponent - 8'd127;
    
    // Optimized multiplier (12x24 + 12x24 with carry-save)
    wire [23:0] b_low = b_mantissa[11:0];
    wire [23:0] b_high = b_mantissa[23:12];
    wire [35:0] pp0_inter = a_mantissa * b_low;
    wire [35:0] pp1_inter = a_mantissa * b_high;
    
    // Normalization and rounding
    wire product_msb = sum[47];
    wire [23:0] norm_mantissa = product_msb ? sum[47:24] : sum[46:23];
    wire [7:0] norm_exponent = product_msb ? (exp_biased + 1) : exp_biased;
    wire round_inc = sum[22] && (sum[21] || (|sum[20:0]) || norm_mantissa[0]);
    
    // Output selection
    wire overflow = &norm_exponent || (exp_biased > 8'hFE);
    wire underflow = (norm_exponent == 0) || (exp_biased < 8'h80);
    wire [31:0] normal_out = {z_sign, norm_exponent, norm_mantissa[22:0]};
    wire [31:0] overflow_out = {z_sign, 8'hFF, 23'b0};
    wire [31:0] underflow_out = {z_sign, 31'b0};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
            special_valid <= 0;
        end else begin
            case (stage)
                0: begin  // Stage 1: Input and special cases
                    special_valid <= special_case;
                    special_reg <= special_result;
                    
                    if (!special_case) begin
                        a_exponent <= a_exp;
                        b_exponent <= b_exp;
                        a_mantissa <= (|a_exp) ? {1'b1, a_frac} : {1'b0, a_frac};
                        b_mantissa <= (|b_exp) ? {1'b1, b_frac} : {1'b0, b_frac};
                        z_sign <= a_sign ^ b_sign;
                    end
                    stage <= 1;
                end
                
                1: begin  // Stage 2: Partial products
                    if (!special_valid) begin
                        pp0 <= pp0_inter[23:0];
                        pp1 <= pp1_inter[23:0];
                        sum <= {12'b0, pp0_inter[35:24]} + {pp1_inter, 12'b0};
                        carry <= 48'b0;
                    end
                    stage <= 2;
                end
                
                2: begin  // Stage 3: Final addition and normalization
                    if (!special_valid) begin
                        // Final addition with carry propagation
                        sum <= sum + (carry << 1);
                        need_round <= sum[22] && (sum[21] || (|sum[20:0]));
                    end
                    stage <= 3;
                end
                
                3: begin  // Stage 4: Rounding and output
                    if (special_valid) begin
                        z <= special_reg;
                    end else if (overflow) begin
                        z <= overflow_out;
                    end else if (underflow) begin
                        z <= underflow_out;
                    end else begin
                        z <= {z_sign, norm_exponent + (round_inc & (&norm_mantissa)), 
                              round_inc ? (norm_mantissa[22:0] + 1) : norm_mantissa[22:0]};
                    end
                    stage <= 0;
                end
            endcase
        end
    end

endmodule