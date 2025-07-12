module float_multi (
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] z
);

// Extract fields
wire a_sign = a[31];
wire [7:0] a_exp_raw = a[30:23];
wire [22:0] a_frac = a[22:0];

wire b_sign = b[31];
wire [7:0] b_exp_raw = b[30:23];
wire [22:0] b_frac = b[22:0];

// Output sign
wire z_sign = a_sign ^ b_sign;

// Detect special inputs
wire a_exp_all_ones = (a_exp_raw == 8'hFF);
wire b_exp_all_ones = (b_exp_raw == 8'hFF);
wire a_exp_zero = (a_exp_raw == 8'h00);
wire b_exp_zero = (b_exp_raw == 8'h00);

wire a_is_nan = a_exp_all_ones && (|a_frac);
wire b_is_nan = b_exp_all_ones && (|b_frac);
wire a_is_inf = a_exp_all_ones && (~|a_frac);
wire b_is_inf = b_exp_all_ones && (~|b_frac);
wire a_is_zero = a_exp_zero && (~|a_frac);
wire b_is_zero = b_exp_zero && (~|b_frac);

// Prepare mantissas with implicit leading bit
// For normals, leading 1; for subnormals, leading 0
wire [23:0] a_mantissa_init = a_exp_zero ? {1'b0, a_frac} : {1'b1, a_frac};
wire [23:0] b_mantissa_init = b_exp_zero ? {1'b0, b_frac} : {1'b1, b_frac};

// Normalize subnormals by counting leading zeros and shifting mantissa left
function [4:0] leading_zero_count_24;
    input [23:0] value;
    integer i;
    begin
        leading_zero_count_24 = 0;
        for (i = 23; i >= 0; i=i-1) begin
            if (value[i] == 1'b0)
                leading_zero_count_24 = leading_zero_count_24 + 1;
            else
                i = -1; // break
        end
    end
endfunction

wire [4:0] a_lz = a_exp_zero ? leading_zero_count_24(a_mantissa_init) : 5'd0;
wire [4:0] b_lz = b_exp_zero ? leading_zero_count_24(b_mantissa_init) : 5'd0;

// Normalize mantissa and adjust exponent accordingly
wire [23:0] a_mantissa = a_exp_zero ? (a_mantissa_init << a_lz) : a_mantissa_init;
wire [7:0] a_exp = a_exp_zero ? 8'd1 - a_lz : a_exp_raw;

wire [23:0] b_mantissa = b_exp_zero ? (b_mantissa_init << b_lz) : b_mantissa_init;
wire [7:0] b_exp = b_exp_zero ? 8'd1 - b_lz : b_exp_raw;

// 24x24 multiply mantissas -> 48 bits product
wire [47:0] product = a_mantissa * b_mantissa;

// Add exponents and subtract bias 127
// Use 10 bits for safe addition and subtraction
wire [9:0] exp_sum = a_exp + b_exp - 8'd127;

// Normalize product mantissa:  
// product[47:24] is candidate mantissa bits, but need to check top bit for normalization
wire product_msb = product[47];
wire [47:0] normalized_product = product_msb ? product : (product << 1);
wire [9:0] normalized_exp = product_msb ? exp_sum + 1 : exp_sum;

// Extract mantissa and rounding bits:
// Mantissa = bits [46:24] (23 bits)
// Guard bit = bit 23
// Round bit = bit 22
// Sticky bit = OR of bits [21:0]
wire [22:0] mantissa_field = normalized_product[46:24];
wire guard_bit = normalized_product[23];
wire round_bit = normalized_product[22];
wire sticky_bit = |normalized_product[21:0];

// Round to nearest even
wire round_increment = (guard_bit && (round_bit || sticky_bit || mantissa_field[0]));
wire [23:0] mantissa_rounded_pre = {1'b0, mantissa_field} + round_increment;

// Handle mantissa overflow due to rounding (carry out)
wire mantissa_overflow = mantissa_rounded_pre[23];

// Final exponent and mantissa after rounding
wire [9:0] exp_final = mantissa_overflow ? (normalized_exp + 1) : normalized_exp;
wire [22:0] mantissa_final = mantissa_overflow ? mantissa_rounded_pre[23:1] : mantissa_rounded_pre[22:0];

// Handle overflow and underflow
wire overflow = (exp_final >= 10'd255);
wire underflow = (exp_final <= 10'd0);

// Handle subnormal underflow:
// If exponent <= 0 but > -23, shift mantissa right accordingly to create subnormal
wire [7:0] exp_clamped = overflow ? 8'hFF :
                        underflow ? 8'h00 :
                        exp_final[7:0];

wire [23:0] mantissa_subnormal = (underflow && (exp_final > -23)) ?
    (mantissa_final >> (1 - exp_final)) : // shift right for subnormal
    {1'b0, mantissa_final};

// If underflow beyond subnormal range, output zero mantissa
wire underflow_too_small = (underflow && (exp_final <= -23));

// Special result selection logic
// Priority:
// NaN if input NaN or Inf*0
// Infinity if Inf*non-zero or overflow
// Zero if zero*anything or underflow too small
// Else normal or subnormal number

wire special_nan = a_is_nan || b_is_nan || (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);
wire special_inf = (!special_nan) && (a_is_inf || b_is_inf || overflow);
wire special_zero = (!special_nan && !special_inf) && (a_is_zero || b_is_zero || underflow_too_small);

// Assemble final output
assign z = special_nan ? {1'b0, 8'hFF, 1'b1, 22'b0} :     // Quiet NaN: mantissa MSB=1, rest zero
           special_inf ? {z_sign, 8'hFF, 23'b0} :
           special_zero ? {z_sign, 31'b0} :
           {z_sign, exp_clamped, mantissa_subnormal[22:0]};

endmodule