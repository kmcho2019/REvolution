module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);
    localparam EXP_BIAS = 127;

    // Input fields (registered)
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Mantissas with implicit leading one (or zero for denormals) extended with 1 bit zero for rounding safety
    reg [24:0] a_mantissa, b_mantissa;

    // Internal signals for combinational logic
    reg [49:0] product;       // 25x25 = 50 bit product
    reg [9:0]  exp_sum;       // 10-bit exponent sum including bias adjustment
    reg        sign_z;

    // Special cases
    reg a_is_zero, b_is_zero;
    reg a_is_inf, b_is_inf;
    reg a_is_nan, b_is_nan;

    // Normalization signals
    reg [49:0] norm_product;
    reg [9:0]  norm_exp;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Mantissa after rounding
    reg [24:0] mant_round;
    reg [23:0] mant_final;
    reg [9:0]  exp_final;

    // Flags for output
    reg special_nan;
    reg special_inf;
    reg special_zero;
    reg special_nan_from_inf_zero; // inf * zero = NaN

    // Helper functions
    function is_zero(input [7:0] e, input [22:0] f);
        is_zero = (e == 8'd0) && (f == 23'd0);
    endfunction

    function is_inf(input [7:0] e, input [22:0] f);
        is_inf = (e == 8'hFF) && (f == 23'd0);
    endfunction

    function is_nan(input [7:0] e, input [22:0] f);
        is_nan = (e == 8'hFF) && (f != 23'd0);
    endfunction

    // Register inputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign   <= 1'b0;
            b_sign   <= 1'b0;
            a_exp    <= 8'd0;
            b_exp    <= 8'd0;
            a_frac   <= 23'd0;
            b_frac   <= 23'd0;
            z        <= 32'd0;
        end else begin
            a_sign   <= a[31];
            b_sign   <= b[31];
            a_exp    <= a[30:23];
            b_exp    <= b[30:23];
            a_frac   <= a[22:0];
            b_frac   <= b[22:0];
            z        <= z_next;
        end
    end

    // Combinational logic for output calculation
    reg [31:0] z_next;

    always @(*) begin
        // Special cases detection
        a_is_zero = is_zero(a_exp, a_frac);
        b_is_zero = is_zero(b_exp, b_frac);
        a_is_inf  = is_inf(a_exp, a_frac);
        b_is_inf  = is_inf(b_exp, b_frac);
        a_is_nan  = is_nan(a_exp, a_frac);
        b_is_nan  = is_nan(b_exp, b_frac);

        // Compute mantissas with implicit leading 1 for normal, 0 for denormals, plus extra bit zero LSB
        a_mantissa = (a_exp == 8'd0) ? {1'b0, a_frac, 1'b0} : {1'b1, a_frac, 1'b0};
        b_mantissa = (b_exp == 8'd0) ? {1'b0, b_frac, 1'b0} : {1'b1, b_frac, 1'b0};

        // Sign calculation
        sign_z = a_sign ^ b_sign;

        // Exponent sum with bias subtraction, 10-bit width for overflow detection
        exp_sum = a_exp + b_exp - EXP_BIAS;

        // Multiply mantissas 25x25 -> 50 bits
        product = a_mantissa * b_mantissa;

        // Special output conditions
        special_nan = a_is_nan || b_is_nan;
        special_nan_from_inf_zero = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);
        special_inf = (a_is_inf || b_is_inf) && !special_nan_from_inf_zero && !special_nan;
        special_zero = (a_is_zero || b_is_zero) && !special_nan_from_inf_zero && !special_nan && !special_inf;

        // Normalization:
        // Product can be 0 to 2 (since mantissas are [0,2) approx.)
        // Check top two bits [49:48] to normalize product mantissa:
        // If product[49] == 1, shift right 1, add 1 to exponent
        // Else shift left if product[48] == 0 (subnormal product), but usually doesn't happen here because mantissas are >=0.0
        if (product[49]) begin
            norm_product = product >> 1;
            norm_exp = exp_sum + 10'd1;
        end else begin
            norm_product = product;
            norm_exp = exp_sum;
        end

        // Extract mantissa bits for final (23 bits + 1 leading implicit bit + rounding bits)
        // Bits [48:24] gives 25 bits: [48] implicit leading 1, [47:25] fraction bits, [24] guard bit
        // We'll separate the rounding bits guard, round, sticky from the lower bits below bit 24
        mant_final = norm_product[48:25];

        guard_bit = norm_product[24];
        round_bit = norm_product[23];
        sticky_bit = |norm_product[22:0];

        // Round to nearest even
        if (guard_bit && (round_bit || sticky_bit || mant_final[0])) begin
            mant_round = {1'b0, mant_final} + 25'd1;
        end else begin
            mant_round = {1'b0, mant_final};
        end

        // Check if rounding caused mantissa overflow (bit 24 set)
        if (mant_round[24]) begin
            mant_final = mant_round[24:1]; // Shift right 1
            exp_final = norm_exp + 10'd1;
        end else begin
            mant_final = mant_round[23:0];
            exp_final = norm_exp;
        end

        // Handle special cases and output assignment
        if (special_nan) begin
            // Quiet NaN: sign=0, exp=all 1's, mantissa MSB=1, others zero
            z_next = {1'b0, 8'hFF, 1'b1, 22'd0};
        end else if (special_nan_from_inf_zero) begin
            // inf*zero = NaN
            z_next = {1'b0, 8'hFF, 1'b1, 22'd0};
        end else if (special_inf) begin
            // Infinity: sign computed, exp=all 1's, frac=0
            z_next = {sign_z, 8'hFF, 23'd0};
        end else if (special_zero) begin
            // Zero: sign computed, exp=0, frac=0
            z_next = {sign_z, 31'd0};
        end else if (exp_final[9]) begin
            // Overflow, exponent too large, output infinity
            z_next = {sign_z, 8'hFF, 23'd0};
        end else if (exp_final <= 0) begin
            // Underflow to zero (do not generate subnormals for simplicity)
            z_next = {sign_z, 31'd0};
        end else begin
            // Normalized number
            z_next = {sign_z, exp_final[7:0], mant_final[22:0]};
        end
    end

endmodule