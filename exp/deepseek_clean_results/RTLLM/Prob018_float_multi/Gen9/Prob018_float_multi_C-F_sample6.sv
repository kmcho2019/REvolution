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

    // Pipeline registers
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_s, b_s;
    
    reg [47:0] product;
    reg [8:0] exp_sum;
    reg sign_inter;
    
    reg [23:0] z_mantissa;
    reg [8:0] z_exponent;
    reg z_sign;

    // Special case detection (combinational, early)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a_exp) && (a_frac == 0);
    wire b_inf = (&b_exp) && (b_frac == 0);
    wire a_nan = (&a_exp) && (|a_frac);
    wire b_nan = (&b_exp) && (|b_frac);
    wire special_case = a_nan | b_nan | ((a_inf | b_inf) & (a_zero | b_zero));

    // Exponent calculation (combinational)
    wire [8:0] exp_biased = {1'b0, a_exponent} + {1'b0, b_exponent} - 9'd127;

    // Multiplication (combinational)
    wire [47:0] product_inter = a_mantissa * b_mantissa;

    // Normalization (combinational)
    wire product_msb = product[47];
    wire [23:0] norm_mantissa = product_msb ? product[47:24] : product[46:23];
    wire [8:0] norm_exponent = product_msb ? (exp_sum + 1) : exp_sum;

    // Rounding (combinational)
    wire guard_bit = product[22];
    wire round_bit = product[21];
    wire sticky = |product[20:0];
    wire round_inc = guard_bit && (round_bit || sticky || norm_mantissa[0]);
    wire [23:0] rounded_mantissa = round_inc ? norm_mantissa + 1 : norm_mantissa;
    wire [8:0] final_exponent = (&norm_mantissa && round_inc) ? norm_exponent + 1 : norm_exponent;

    // Output selection (combinational)
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {z_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {z_sign, 31'b0};
    wire [31:0] normal_out = {z_sign, final_exponent[7:0], rounded_mantissa[22:0]};
    wire overflow = &final_exponent[7:0] || final_exponent[8];
    wire underflow = (final_exponent == 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
        end else begin
            case (stage)
                0: begin  // Stage 1: Input decomposition
                    a_s <= a_sign;
                    b_s <= b_sign;
                    a_exponent <= a_exp;
                    b_exponent <= b_exp;
                    a_mantissa <= (|a_exp) ? {1'b1, a_frac} : {1'b0, a_frac};
                    b_mantissa <= (|b_exp) ? {1'b1, b_frac} : {1'b0, b_frac};
                    stage <= 1;
                end
                
                1: begin  // Stage 2: Multiplication
                    product <= product_inter;
                    exp_sum <= exp_biased;
                    sign_inter <= a_s ^ b_s;
                    stage <= 2;
                end
                
                2: begin  // Stage 3: Normalization
                    z_mantissa <= norm_mantissa;
                    z_exponent <= norm_exponent;
                    z_sign <= sign_inter;
                    stage <= 3;
                end
                
                3: begin  // Stage 4: Rounding
                    // Apply rounding if needed
                    if (round_inc) begin
                        z_mantissa <= rounded_mantissa;
                        z_exponent <= final_exponent;
                    end
                    stage <= 4;
                end
                
                4: begin  // Stage 5: Output
                    // Priority-based output selection
                    if (a_nan || b_nan) z <= nan_out;
                    else if (special_case) z <= nan_out;
                    else if (a_inf || b_inf) z <= inf_out;
                    else if (a_zero || b_zero) z <= zero_out;
                    else if (overflow) z <= inf_out;
                    else if (underflow) z <= zero_out;
                    else z <= normal_out;
                    
                    stage <= 0;
                end
            endcase
        end
    end

endmodule