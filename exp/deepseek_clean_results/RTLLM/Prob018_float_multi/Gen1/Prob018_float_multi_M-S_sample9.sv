module float_multi (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    // Special cases
    wire a_zero = (a_exp == 0) && (a_frac == 0);
    wire b_zero = (b_exp == 0) && (b_frac == 0);
    wire a_inf = (a_exp == 8'hFF) && (a_frac == 0);
    wire b_inf = (b_exp == 8'hFF) && (b_frac == 0);
    wire a_nan = (a_exp == 8'hFF) && (a_frac != 0);
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 0);

    // Result components
    wire z_sign = a_sign ^ b_sign;
    wire [7:0] z_exp;
    wire [22:0] z_frac;

    // Handle special cases with priority
    always @(*) begin
        if (a_nan || b_nan || (a_zero && b_inf) || (a_inf && b_zero)) begin
            z = {1'b0, 8'hFF, 23'h7FFFFF}; // NaN
        end else if (a_inf || b_inf) begin
            z = {z_sign, 8'hFF, 23'h0}; // Infinity
        end else if (a_zero || b_zero) begin
            z = {z_sign, 31'h0}; // Zero
        end else begin
            // Normal case
            z = {z_sign, z_exp, z_frac};
        end
    end

    // Exponent calculation
    wire [8:0] exp_sum = {1'b0, a_exp} + {1'b0, b_exp} - 127;
    
    // Mantissa multiplication
    wire [23:0] a_mant = (a_exp == 0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mant = (b_exp == 0) ? {1'b0, b_frac} : {1'b1, b_frac};
    wire [47:0] product = a_mant * b_mant;

    // Normalization
    wire norm_shift = ~product[47];
    wire [47:0] norm_product = norm_shift ? product << 1 : product;
    wire [8:0] norm_exp = exp_sum + norm_shift;

    // Handle overflow/underflow
    wire overflow = (norm_exp[8] || (norm_exp[7:0] >= 255));
    wire underflow = (norm_exp < 127);
    
    assign z_exp = overflow ? 8'hFF : 
                  underflow ? 8'h00 : 
                  norm_exp[7:0] - 126;

    // Final fraction (with simple truncation rounding)
    assign z_frac = overflow ? 23'h0 : 
                    underflow ? 23'h0 : 
                    norm_product[46:24];

endmodule