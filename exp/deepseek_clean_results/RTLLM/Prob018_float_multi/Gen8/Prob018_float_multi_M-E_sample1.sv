module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Early special case detection
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
    wire b_nan = (b_exp == 8'hFF) && (b_frac != 0);
    
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;
    wire [31:0] special_result;
    assign special_result = (a_nan | b_nan | (a_inf & b_zero) | (a_zero & b_inf)) ? 
                          {1'b0, 8'hFF, 1'b1, 22'b0} : // NaN
                          (a_inf | b_inf) ? {a_sign ^ b_sign, 8'hFF, 23'b0} : // Inf
                          {a_sign ^ b_sign, 31'b0}; // Zero

    // Normal path processing
    reg [15:0] a_upper, b_upper;
    reg [7:0] a_lower, b_lower;
    reg [7:0] exp_sum;
    reg sign_reg;

    // Partial products
    reg [31:0] pp_uu; // Upper x Upper
    reg [23:0] pp_ul; // Upper x Lower
    reg [23:0] pp_lu; // Lower x Upper
    reg [15:0] pp_ll; // Lower x Lower

    // Accumulated product
    reg [47:0] product;

    // Normalization and rounding
    reg [22:0] final_mantissa;
    reg [7:0] final_exponent;
    reg final_sign;

    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
            product <= 0;
        end else if (special_case) begin
            z <= special_result;
        end else begin
            // Stage 1: Input preparation
            a_upper <= (a_exp == 0) ? {1'b0, a_frac[22:8]} : {1'b1, a_frac[22:8]};
            b_upper <= (b_exp == 0) ? {1'b0, b_frac[22:8]} : {1'b1, b_frac[22:8]};
            a_lower <= a_frac[7:0];
            b_lower <= b_frac[7:0];
            exp_sum <= a_exp + b_exp - 127;
            sign_reg <= a_sign ^ b_sign;

            // Stage 2: Partial multiplications
            pp_uu <= a_upper * b_upper;
            pp_ul <= a_upper * b_lower;
            pp_lu <= a_lower * b_upper;
            pp_ll <= a_lower * b_lower;

            // Stage 3: Product accumulation
            product <= {pp_uu, 16'b0} + 
                      {8'b0, pp_ul, 8'b0} + 
                      {8'b0, pp_lu, 8'b0} + 
                      {16'b0, pp_ll};

            // Stage 4: Normalization and rounding
            if (product[47]) begin
                final_mantissa <= product[46:24] + (product[23] & (product[22] | |product[21:0]));
                final_exponent <= exp_sum + 1;
            end else begin
                final_mantissa <= product[45:23] + (product[22] & (product[21] | |product[20:0]));
                final_exponent <= exp_sum;
            end
            final_sign <= sign_reg;

            // Stage 5: Output formatting
            if (final_exponent[7] & !final_exponent[8]) begin // Underflow
                z <= {final_sign, 31'b0};
            end else if (&final_exponent[7:0]) begin // Overflow
                z <= {final_sign, 8'hFF, 23'b0};
            end else begin
                z <= {final_sign, final_exponent[7:0], final_mantissa};
            end
        end
    end

endmodule