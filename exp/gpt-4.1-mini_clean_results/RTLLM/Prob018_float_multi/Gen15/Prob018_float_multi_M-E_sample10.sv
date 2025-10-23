module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    // Constants
    localparam EXP_BIAS = 127;

    // State machine states: idle (wait inputs), compute (1 cycle compute), done (register output)
    localparam IDLE = 3'd0;
    localparam COMPUTE = 3'd1;
    localparam DONE = 3'd2;

    reg [2:0] state;
    reg [31:0] a_reg, b_reg;

    // Extract fields from registered inputs
    wire a_sign = a_reg[31];
    wire b_sign = b_reg[31];
    wire [7:0] a_exp = a_reg[30:23];
    wire [7:0] b_exp = b_reg[30:23];
    wire [22:0] a_frac = a_reg[22:0];
    wire [22:0] b_frac = b_reg[22:0];

    // Detect special cases combinationally
    wire a_is_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_is_zero = (b_exp == 8'd0) && (b_frac == 23'd0);

    wire a_is_inf = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_is_inf = (b_exp == 8'hFF) && (b_frac == 23'd0);

    wire a_is_nan = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_is_nan = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Mantissas with implicit leading 1 for normalized, 0 for denormals
    wire [23:0] a_mantissa = (a_exp == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
    wire [23:0] b_mantissa = (b_exp == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

    // Sign of result
    wire sign_res = a_sign ^ b_sign;

    // Exponent addition with bias subtraction done combinationally
    wire [9:0] exp_add_raw = a_exp + b_exp; // 9 bits needed for sum
    wire signed [10:0] exp_sum = $signed({1'b0, exp_add_raw}) - $signed(EXP_BIAS);

    // 24x24 multiplication of mantissas
    wire [47:0] mant_product = a_mantissa * b_mantissa;

    // Normalization: if MSB of product is 1 at bit 47 -> normalized, else shift left once and decrease exponent
    wire msb_47 = mant_product[47];

    // Normalized mantissa (24 bits) and exponent adjusted accordingly
    wire [23:0] norm_mantissa = msb_47 ? mant_product[47:24] : mant_product[46:23];
    wire signed [10:0] norm_exp = msb_47 ? exp_sum + 11'sd1 : exp_sum;

    // Rounding bits: guard, round, sticky (bits below mantissa LSB)
    wire guard_bit = msb_47 ? mant_product[23] : mant_product[22];
    wire round_bit = msb_47 ? mant_product[22] : mant_product[21];
    wire sticky_bits_in = msb_47 ? mant_product[21:0] : mant_product[20:0];
    wire sticky_bit = |sticky_bits_in;

    // Round to nearest even logic:
    // If guard=1 and (round=1 or sticky=1 or LSB=1) then round up
    wire round_increment = guard_bit && (round_bit || sticky_bit || norm_mantissa[0]);

    // Mantissa with rounding, 25 bits wide to check overflow after rounding
    wire [24:0] mant_rounded_pre = {1'b0, norm_mantissa} + round_increment;

    // Check if rounding caused mantissa overflow (bit 24)
    wire mantissa_overflow = mant_rounded_pre[24];

    // Adjust exponent if mantissa overflow
    wire signed [10:0] final_exp = mantissa_overflow ? norm_exp + 11'sd1 : norm_exp;
    wire [22:0] final_mantissa = mantissa_overflow ? mant_rounded_pre[24:2] : mant_rounded_pre[22:0];

    // Final exponent truncated to 8 bits
    wire [7:0] final_exp8 = final_exp[7:0];

    // Flags for special cases that propagate to output
    wire special_nan = a_is_nan | b_is_nan;
    wire special_inf_zero = (a_is_inf & b_is_zero) | (b_is_inf & a_is_zero);
    wire special_inf = (a_is_inf & ~b_is_zero & ~b_is_nan) | (b_is_inf & ~a_is_zero & ~a_is_nan);
    wire special_zero = (a_is_zero & ~b_is_inf & ~b_is_nan) | (b_is_zero & ~a_is_inf & ~a_is_nan);

    // Overflow / underflow detection
    wire overflow = final_exp >= 11'sd255; // Exponent too large for single precision
    wire underflow = final_exp <= 0; // Too small exponent (underflow)

    // Compose final output combinationally
    reg [31:0] out_final;

    always @(*) begin
        if (special_nan) begin
            // Quiet NaN: sign=0, exp=255, MSB mantissa = 1
            out_final = {1'b0, 8'hFF, 1'b1, 22'd0};
        end else if (special_inf_zero) begin
            // Invalid operation NaN (Inf * 0)
            out_final = {1'b0, 8'hFF, 1'b1, 22'd0};
        end else if (special_inf) begin
            out_final = {sign_res, 8'hFF, 23'd0};
        end else if (special_zero) begin
            out_final = {sign_res, 31'd0};
        end else begin
            if (overflow) begin
                // Infinity on overflow
                out_final = {sign_res, 8'hFF, 23'd0};
            end else if (underflow) begin
                // Flush to zero on underflow (no subnormals)
                out_final = {sign_res, 31'd0};
            end else begin
                // Normal case
                out_final = {sign_res, final_exp8, final_mantissa};
            end
        end
    end

    // State machine and output register update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            z <= 32'd0;
        end else begin
            case (state)
                IDLE: begin
                    // Latch inputs and start compute next cycle
                    a_reg <= a;
                    b_reg <= b;
                    state <= COMPUTE;
                end
                COMPUTE: begin
                    // Compute done combinationally, latch output
                    z <= out_final;
                    state <= DONE;
                end
                DONE: begin
                    // Hold output stable; wait for next inputs
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule