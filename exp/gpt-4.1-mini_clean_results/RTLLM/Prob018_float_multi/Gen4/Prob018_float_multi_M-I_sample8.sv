module float_multi (
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);

// Internal registers
reg [2:0] counter;

// Registers to hold extracted fields
reg        a_sign, b_sign, z_sign;
reg signed [9:0]  a_exponent, b_exponent, z_exponent;  // signed to handle underflow
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [47:0] product; // 24x24 multiplication produces up to 48 bits

reg guard_bit, round_bit, sticky_bit;

// Internal flags for special cases
reg a_is_zero, b_is_zero;
reg a_is_inf,  b_is_inf;
reg a_is_nan,  b_is_nan;

reg special_nan, special_inf, special_zero;

reg rounding_increment;
reg mantissa_overflow;

// Function: Count leading zeros of a 24-bit input.
// Returns a 5-bit count (0 to 24).
function [4:0] leading_zero_count_24;
    input [23:0] value;
    integer i;
    begin
        leading_zero_count_24 = 0;
        for (i = 23; i >= 0; i = i - 1) begin
            if (value[i] == 1'b0)
                leading_zero_count_24 = leading_zero_count_24 + 1;
            else
                i = -1; // break loop early
        end
    end
endfunction

// Sticky bit calculation: OR of bits, returns 1 if any bit is 1
function sticky_calc;
    input [21:0] bits;
    integer i;
    begin
        sticky_calc = 1'b0;
        for(i=0; i < 22; i=i+1) begin
            sticky_calc = sticky_calc | bits[i];
        end
    end
endfunction

always @(posedge clk) begin
    if (rst) begin
        counter      <= 3'd0;
        z            <= 32'd0;
        a_sign       <= 1'b0;
        b_sign       <= 1'b0;
        z_sign       <= 1'b0;
        a_exponent   <= 10'd0;
        b_exponent   <= 10'd0;
        z_exponent   <= 10'd0;
        a_mantissa   <= 24'd0;
        b_mantissa   <= 24'd0;
        z_mantissa   <= 24'd0;
        product      <= 48'd0;
        guard_bit    <= 1'b0;
        round_bit    <= 1'b0;
        sticky_bit   <= 1'b0;
        a_is_zero    <= 1'b0;
        b_is_zero    <= 1'b0;
        a_is_inf     <= 1'b0;
        b_is_inf     <= 1'b0;
        a_is_nan     <= 1'b0;
        b_is_nan     <= 1'b0;
        special_nan  <= 1'b0;
        special_inf  <= 1'b0;
        special_zero <= 1'b0;
        rounding_increment <= 1'b0;
        mantissa_overflow <= 1'b0;
    end else begin
        case (counter)
        3'd0: begin
            // Extract sign, exponent, and mantissa fields
            a_sign <= a[31];
            b_sign <= b[31];
            z_sign <= a[31] ^ b[31];

            a_exponent <= {2'b00, a[30:23]};
            b_exponent <= {2'b00, b[30:23]};
            
            // For normal numbers, implicit 1 at MSB; for subnormal 0.
            a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

            // Detect special cases
            a_is_nan  <= (a[30:23] == 8'hFF) && (|a[22:0]);
            b_is_nan  <= (b[30:23] == 8'hFF) && (|b[22:0]);
            a_is_inf  <= (a[30:23] == 8'hFF) && (~|a[22:0]);
            b_is_inf  <= (b[30:23] == 8'hFF) && (~|b[22:0]);
            a_is_zero <= (a[30:23] == 8'd0) && (~|a[22:0]);
            b_is_zero <= (b[30:23] == 8'd0) && (~|b[22:0]);

            special_nan  <= 1'b0;
            special_inf  <= 1'b0;
            special_zero <= 1'b0;

            // Clear outputs and intermediates
            product <= 48'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
            rounding_increment <= 1'b0;
            mantissa_overflow <= 1'b0;
            z <= 32'd0;

            counter <= counter + 3'd1;
        end
        3'd1: begin
            // Normalize subnormal inputs by left-shifting mantissa and adjusting exponent
            
            // Normalize a if subnormal and non-zero, not special
            if (a[30:23] == 8'd0 && !a_is_zero && !a_is_nan && !a_is_inf) begin
                reg [4:0] lz_a;
                lz_a = leading_zero_count_24(a_mantissa);
                a_mantissa <= a_mantissa << lz_a;
                // Effective exponent: 1 - lz_count, since subnormal exponent is zero
                a_exponent <= 10'd1 - lz_a;
            end

            // Normalize b if subnormal and non-zero, not special
            if (b[30:23] == 8'd0 && !b_is_zero && !b_is_nan && !b_is_inf) begin
                reg [4:0] lz_b;
                lz_b = leading_zero_count_24(b_mantissa);
                b_mantissa <= b_mantissa << lz_b;
                b_exponent <= 10'd1 - lz_b;
            end

            counter <= counter + 3'd1;
        end
        3'd2: begin
            // Handle special cases and prepare multiplication
            
            // Identify special results
            // NaN if any input NaN or Inf*0
            special_nan  <= a_is_nan || b_is_nan || ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero));
            // Inf if no NaN and any input Inf
            special_inf  <= (!special_nan) && (a_is_inf || b_is_inf);
            // Zero if no NaN, no Inf, and any input zero
            special_zero <= (!special_nan && !special_inf) && (a_is_zero || b_is_zero);

            if (special_nan || special_inf || special_zero) begin
                product <= 48'd0;
                z_exponent <= 10'd0;
                z_mantissa <= 24'd0;
            end else begin
                // Compute exponent sum and subtract bias 127
                z_exponent <= a_exponent + b_exponent - 10'd127;

                // Perform mantissa multiplication 24x24 => 48 bits
                product <= a_mantissa * b_mantissa;
            end
            counter <= counter + 3'd1;
        end
        3'd3: begin
            if (special_nan || special_inf || special_zero) begin
                // No normalization needed for special cases
                guard_bit <= 1'b0;
                round_bit <= 1'b0;
                sticky_bit <= 1'b0;
                z_mantissa <= 24'd0;
            end else begin
                // Normalize the product and adjust exponent accordingly
                // product is 48 bits: product[47:0]
                reg [47:0] product_norm;
                reg signed [9:0] exp_adj;
                reg [23:0] mantissa_norm;
                reg g, r, s;
                // Normalization:
                // If MSB product[47] == 1, no shift, exponent += 1
                // Else shift left by 1, exponent unchanged

                exp_adj = z_exponent;
                if (product[47] == 1'b1) begin
                    product_norm = product;
                    exp_adj = exp_adj + 1;
                end else begin
                    product_norm = product << 1;
                    // exponent unchanged if shifted left
                end

                // Mantissa bits: top 24 bits excluding implicit leading 1
                // For IEEE-754, we store bits [46:24] (23 bits mantissa + implicit bit handled by normalization)
                // Rounding bits: guard bit = bit 23, round bit = bit 22, sticky bit = OR of bits 21 down to 0

                mantissa_norm = product_norm[46:23];
                g = product_norm[22];
                r = product_norm[21];
                s = |product_norm[20:0];

                // Update outputs accordingly
                z_mantissa <= mantissa_norm;
                guard_bit <= g;
                round_bit <= r;
                sticky_bit <= s;
                z_exponent <= exp_adj;
            end
            counter <= counter + 3'd1;
        end
        3'd4: begin
            if (special_nan || special_inf || special_zero) begin
                rounding_increment <= 1'b0;
                mantissa_overflow <= 1'b0;
            end else begin
                // Round to nearest even:
                // Round if guard=1 and (round=1 or sticky=1 or mantissa LSB=1)
                rounding_increment <= guard_bit && (round_bit || sticky_bit || z_mantissa[0]);

                {mantissa_overflow, z_mantissa} <= z_mantissa + rounding_increment;
            end
            counter <= counter + 3'd1;
        end
        3'd5: begin
            // Compose final output or special cases
            if (special_nan) begin
                // Quiet NaN: Exponent=0xFF, mantissa MSB=1 (bit 22), rest zero
                z <= {1'b0, 8'hFF, 1'b1, 22'b0};
            end else if (special_inf) begin
                // Infinity: sign, exponent=0xFF, mantissa=0
                z <= {z_sign, 8'hFF, 23'd0};
            end else if (special_zero) begin
                // Zero: sign, exponent=0, mantissa=0
                z <= {z_sign, 31'd0};
            end else begin
                reg signed [9:0] exp_out;
                reg [23:0] mant_out;
                reg [31:0] result;

                exp_out = z_exponent;
                mant_out = z_mantissa;

                // If mantissa overflowed after rounding, shift right and increment exponent
                if (mantissa_overflow) begin
                    mant_out = mant_out >> 1;
                    exp_out = exp_out + 1;
                end

                // Handle exponent overflow -> Infinity
                if (exp_out >= 10'sd255) begin
                    // Overflow to infinity
                    result = {z_sign, 8'hFF, 23'd0};
                end
                // Handle exponent underflow -> zero or subnormal
                else if (exp_out <= 0) begin
                    if (exp_out < -23) begin
                        // Too small, underflow to zero
                        result = {z_sign, 31'd0};
                    end else begin
                        // Subnormal number: shift mantissa right by (1 - exp_out)
                        // shift_amt is positive here (because exp_out is <=0)
                        integer shift_amt;
                        shift_amt = 1 - exp_out;
                        // Shift mantissa logically, and handle sticky bits for lost bits during shift for rounding?

                        // Compute sticky bit during shifting:
                        reg sticky_shift;
                        reg [23:0] shifted_mant;

                        // Sticky is OR of bits shifted out
                        sticky_shift = |(mant_out[shift_amt-1:0]);
                        shifted_mant = mant_out >> shift_amt;

                        // Round to nearest even for subnormal rounding
                        // For simplicity, round if sticky=1 and LSB=1 (least significant mantissa bit)
                        // Apply rounding:
                        if (sticky_shift && shifted_mant[0]) begin
                            shifted_mant = shifted_mant + 1;
                            // If overflow, mantissa wraps, but exponent is fixed at 0 for subnormal
                        end

                        result = {z_sign, 8'd0, shifted_mant[22:0]};
                    end
                end else begin
                    // Normal number
                    result = {z_sign, exp_out[7:0], mant_out[22:0]};
                end

                z <= result;
            end
            counter <= 3'd0;
        end
        default: begin
            counter <= 3'd0;
        end
        endcase
    end
end

endmodule