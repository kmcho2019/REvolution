module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Input decomposition
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Special case flags
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a_exp) && (a_frac == 0);
    wire b_inf = (&b_exp) && (b_frac == 0);
    wire a_nan = (&a_exp) && (|a_frac);
    wire b_nan = (&b_exp) && (|b_frac);

    // Mantissa with implicit bit
    wire [23:0] a_mant = (|a_exp) ? {1'b1, a_frac} : {1'b0, a_frac};
    wire [23:0] b_mant = (|b_exp) ? {1'b1, b_frac} : {1'b0, b_frac};

    // Intermediate calculations
    wire [47:0] product = a_mant * b_mant;
    wire [9:0] exp_sum = {2'b0, a_exp} + {2'b0, b_exp} - 10'd127;
    wire product_overflow = product[47];
    
    // Normalized mantissa and exponent
    wire [23:0] norm_mant = product_overflow ? product[46:23] : product[45:22];
    wire [9:0] norm_exp = product_overflow ? exp_sum + 1 : exp_sum;
    
    // Rounding bits
    wire guard = product_overflow ? product[22] : product[21];
    wire round = product_overflow ? product[21] : product[20];
    wire sticky = product_overflow ? |product[20:0] : |product[19:0];
    
    // Rounded mantissa
    wire [23:0] rounded_mant = norm_mant + (guard & (round | sticky | norm_mant[0]));
    wire rounded_overflow = &rounded_mant;
    
    // Final exponent after rounding
    wire [9:0] final_exp = rounded_overflow ? norm_exp + 1 : norm_exp;
    
    // Final components before special cases
    wire final_sign = a_sign ^ b_sign;
    wire [7:0] final_exp_8bit = final_exp[7:0];
    wire [22:0] final_frac = rounded_mant[22:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            // Handle special cases with priority
            if (a_nan || b_nan) begin
                z <= 32'h7FC00000;  // Canonical NaN
            end else if (a_inf || b_inf) begin
                if (a_zero || b_zero) begin
                    z <= 32'h7FC00000;  // inf * 0 = NaN
                end else begin
                    z <= {final_sign, 8'hFF, 23'b0};  // +/- inf
                end
            end else if (a_zero || b_zero) begin
                z <= {final_sign, 31'b0};  // +/- 0
            end else if (final_exp[9] || (&final_exp_8bit)) begin  // Overflow
                z <= {final_sign, 8'hFF, 23'b0};  // +/- inf
            end else if (final_exp[8] || (final_exp == 0)) begin  // Underflow
                z <= {final_sign, 31'b0};  // +/- 0
            end else begin  // Normal case
                z <= {final_sign, final_exp_8bit, final_frac};
            end
        end
    end

endmodule