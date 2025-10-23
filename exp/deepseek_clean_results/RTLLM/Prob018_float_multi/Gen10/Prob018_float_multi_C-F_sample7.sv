module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    reg [2:0] stage;

    // Input decomposition
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Special case detection (combinational, early)
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
    
    // Multiplication stage
    reg [47:0] product;
    reg [8:0] exp_sum;
    reg sign_inter;
    
    // Normalization stage
    reg [23:0] z_mantissa;
    reg [8:0] z_exponent;
    reg z_sign;

    // Combinational logic between stages
    wire [8:0] exp_biased = {1'b0, a_exponent} + {1'b0, b_exponent} - 9'd127;
    wire [47:0] product_inter = a_mantissa * b_mantissa;
    
    // Normalization logic
    wire product_msb = product[47];
    wire [23:0] norm_mantissa = product_msb ? product[47:24] : product[46:23];
    wire [8:0] norm_exponent = product_msb ? (exp_sum + 1) : exp_sum;
    
    // Rounding logic
    wire guard_bit = product[22];
    wire round_bit = product[21];
    wire sticky = |product[20:0];
    wire round_inc = guard_bit && (round_bit || sticky || norm_mantissa[0]);
    wire [23:0] rounded_mantissa = round_inc ? norm_mantissa + 1 : norm_mantissa;
    wire [8:0] final_exponent = (&norm_mantissa && round_inc) ? norm_exponent + 1 : norm_exponent;
    
    // Output selection
    wire overflow = &final_exponent[7:0] || final_exponent[8];
    wire underflow = (final_exponent == 0);
    wire [31:0] normal_out = {z_sign, final_exponent[7:0], rounded_mantissa[22:0]};
    wire [31:0] overflow_out = {z_sign, 8'hFF, 23'b0};
    wire [31:0] underflow_out = {z_sign, 31'b0};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
            special_valid <= 0;
        end else begin
            case (stage)
                0: begin  // Stage 1: Input decomposition and special cases
                    special_valid <= special_case;
                    special_reg <= special_result;
                    
                    if (!special_case) begin
                        a_exponent <= a_exp;
                        b_exponent <= b_exp;
                        a_mantissa <= (|a_exp) ? {1'b1, a_frac} : {1'b0, a_frac};
                        b_mantissa <= (|b_exp) ? {1'b1, b_frac} : {1'b0, b_frac};
                        sign_inter <= a_sign ^ b_sign;
                    end
                    stage <= 1;
                end
                
                1: begin  // Stage 2: Multiplication
                    if (!special_valid) begin
                        product <= product_inter;
                        exp_sum <= exp_biased;
                    end
                    stage <= 2;
                end
                
                2: begin  // Stage 3: Normalization
                    if (!special_valid) begin
                        z_mantissa <= norm_mantissa;
                        z_exponent <= norm_exponent;
                        z_sign <= sign_inter;
                    end
                    stage <= 3;
                end
                
                3: begin  // Stage 4: Rounding
                    if (!special_valid && round_inc) begin
                        z_mantissa <= rounded_mantissa;
                        z_exponent <= final_exponent;
                    end
                    stage <= 4;
                end
                
                4: begin  // Stage 5: Output
                    if (special_valid) begin
                        z <= special_reg;
                    end else if (overflow) begin
                        z <= overflow_out;
                    end else if (underflow) begin
                        z <= underflow_out;
                    end else begin
                        z <= normal_out;
                    end
                    stage <= 0;
                end
            endcase
        end
    end

endmodule