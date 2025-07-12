module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Internal registers
    reg [2:0] counter;

    // Extracted input components
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Extended mantissas with implicit 1 for normal numbers, 0 for subnormals
    reg [23:0] a_mantissa, b_mantissa;

    // Intermediate signals for multiplication
    reg [47:0] product;

    // Exponent sum (including bias correction)
    reg [9:0] exp_sum; // 10 bits to hold possible overflow

    // Normalization shift amount and flags
    reg norm_shift;
    
    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa extended for carry
    reg [24:0] mantissa_rounded;

    // Final sign, exponent, mantissa
    reg final_sign;
    reg [7:0] final_exp;
    reg [22:0] final_mant;

    // Special case flags
    wire a_is_zero = (a_exp == 8'd0) && (a_frac == 23'd0);
    wire b_is_zero = (b_exp == 8'd0) && (b_frac == 23'd0);

    wire a_is_inf  = (a_exp == 8'hFF) && (a_frac == 23'd0);
    wire b_is_inf  = (b_exp == 8'hFF) && (b_frac == 23'd0);

    wire a_is_nan  = (a_exp == 8'hFF) && (a_frac != 23'd0);
    wire b_is_nan  = (b_exp == 8'hFF) && (b_frac != 23'd0);

    // Rounding function
    function [24:0] round_mantissa;
        input [23:0] mant;
        input        g;  // guard bit
        input        r;  // round bit
        input        s;  // sticky bit
        reg          round_up;
        reg [24:0]   result;
    begin
        // Round to nearest even
        round_up = g & (r | s | mant[0]);
        result = {1'b0, mant} + (round_up ? 25'd1 : 25'd0);
        round_mantissa = result;
    end
    endfunction

    // Counter logic (increment or reset)
    always @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 3'd0;
        else
            counter <= counter + 3'd1;
    end

    // Capture inputs every cycle for combinational use
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_sign <= 0; b_sign <= 0;
            a_exp <= 0; b_exp <= 0;
            a_frac <= 0; b_frac <= 0;
            a_mantissa <= 0; b_mantissa <= 0;
        end else begin
            a_sign <= a[31];
            b_sign <= b[31];
            a_exp <= a[30:23];
            b_exp <= b[30:23];
            a_frac <= a[22:0];
            b_frac <= b[22:0];

            a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
        end
    end

    // Combinational block for float multiplication
    always @(*) begin
        // Default final output is zero
        final_sign = 1'b0;
        final_exp = 8'd0;
        final_mant = 23'd0;

        // Compute sign (XOR)
        final_sign = a_sign ^ b_sign;

        // Handle special cases (priority order)
        if (a_is_nan || b_is_nan) begin
            // Propagate quiet NaN with MSB of fraction set
            final_exp = 8'hFF;
            final_mant = 23'h400000; // MSB of mantissa set, quiet NaN
        end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
            // Inf * 0 = NaN
            final_exp = 8'hFF;
            final_mant = 23'h400000;
        end else if (a_is_inf || b_is_inf) begin
            // Inf * non-zero = Inf
            final_exp = 8'hFF;
            final_mant = 23'd0;
        end else if (a_is_zero || b_is_zero) begin
            // Zero times anything = zero
            final_exp = 8'd0;
            final_mant = 23'd0;
        end else begin
            // Normal or subnormal multiplication

            // Exponent sum with bias correction
            exp_sum = a_exp + b_exp - 8'd127;

            // Multiply mantissas (24x24)
            product = a_mantissa * b_mantissa; // 48 bits

            // Normalize product:
            // If top bit (bit 47) is 1, shift right by 1 and increment exponent
            if (product[47]) begin
                // Shift right by 1, exponent + 1
                norm_shift = 1'b1;
                // Extract mantissa bits for rounding: [46:23] (24 bits)
                // Guard = bit 22, round = bit 21, sticky = OR of bits 20:0
                guard_bit = product[22];
                round_bit = product[21];
                sticky_bit = |product[20:0];
                // Mantissa before rounding (bits 46 down to 23)
                mantissa_rounded = round_mantissa(product[46:23], guard_bit, round_bit, sticky_bit);
                exp_sum = exp_sum + 1;
            end else begin
                // No shift
                norm_shift = 1'b0;
                // Extract mantissa bits for rounding: [45:22]
                guard_bit = product[21];
                round_bit = product[20];
                sticky_bit = |product[19:0];
                mantissa_rounded = round_mantissa(product[45:22], guard_bit, round_bit, sticky_bit);
            end

            // Adjust exponent and mantissa if rounding causes mantissa overflow
            if (mantissa_rounded[24]) begin
                // Mantissa overflow, shift right by 1, increment exponent
                final_exp = exp_sum + 1;
                final_mant = mantissa_rounded[23:1];
            end else begin
                final_exp = exp_sum;
                final_mant = mantissa_rounded[22:0];
            end

            // Handle exponent overflow/underflow
            if (final_exp >= 8'hFF) begin
                // Overflow to infinity
                final_exp = 8'hFF;
                final_mant = 23'd0;
            end else if (final_exp <= 0) begin
                // Underflow to zero (flush to zero)
                final_exp = 8'd0;
                final_mant = 23'd0;
            end
        end
    end

    // Register output on clock with synchronous reset
    always @(posedge clk or posedge rst) begin
        if (rst)
            z <= 32'd0;
        else
            z <= {final_sign, final_exp, final_mant};
    end

endmodule