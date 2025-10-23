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
reg [9:0]  a_exponent, b_exponent, z_exponent;  // wider for intermediate range
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [49:0] product;

reg guard_bit, round_bit, sticky_bit;

// Internal flags for special cases
reg a_is_zero, b_is_zero;
reg a_is_inf,  b_is_inf;
reg a_is_nan,  b_is_nan;

reg special_nan, special_inf, special_zero;
reg rounding_increment;
reg mantissa_overflow;

integer i;

// Leading zero count for 24-bit input
function [4:0] leading_zero_count_24;
    input [23:0] value;
    integer idx;
    begin
        leading_zero_count_24 = 0;
        for (idx = 23; idx >= 0; idx = idx -1) begin
            if (value[idx] == 1'b0)
                leading_zero_count_24 = leading_zero_count_24 + 1;
            else
                idx = -1; // break
        end
    end
endfunction

// Sticky bit calculation for rounding: OR of lower bits
function sticky_calc;
    input [21:0] bits;
    integer idx;
    begin
        sticky_calc = 1'b0;
        for (idx = 0; idx < 22; idx = idx + 1)
            sticky_calc = sticky_calc | bits[idx];
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
        product      <= 50'd0;
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
            // Extract fields
            a_sign     <= a[31];
            b_sign     <= b[31];
            z_sign     <= a[31] ^ b[31];
            // Exponents extended to 10 bits for overflow/underflow safety
            a_exponent <= {2'b00, a[30:23]};
            b_exponent <= {2'b00, b[30:23]};
            // Mantissas prepended with implicit 1 for normal numbers; 0 for subnormal
            a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
            // Detect special cases
            a_is_nan  <= (a[30:23] == 8'hFF) && (|a[22:0]);
            b_is_nan  <= (b[30:23] == 8'hFF) && (|b[22:0]);
            a_is_inf  <= (a[30:23] == 8'hFF) && (~|a[22:0]);
            b_is_inf  <= (b[30:23] == 8'hFF) && (~|b[22:0]);
            a_is_zero <= (a[30:23] == 8'd0) && (~|a[22:0]);
            b_is_zero <= (b[30:23] == 8'd0) && (~|b[22:0]);
            // Clear special result flags
            special_nan  <= 1'b0;
            special_inf  <= 1'b0;
            special_zero <= 1'b0;
            // Clear product and rounding bits
            product      <= 50'd0;
            guard_bit    <= 1'b0;
            round_bit    <= 1'b0;
            sticky_bit   <= 1'b0;
            rounding_increment <= 1'b0;
            mantissa_overflow <= 1'b0;
            z <= 32'd0;
            counter <= counter + 3'd1;
        end

        3'd1: begin
            // Handle normalization for subnormal inputs
            // For a
            if (a[30:23] == 8'd0 && !a_is_zero && !a_is_nan && !a_is_inf) begin
                // Count leading zeros in mantissa
                // leading_zero_count_24 returns number of leading zeros
                // Shift mantissa left accordingly and adjust exponent
                // Note: Exponent for subnormal starts effectively at 1 - leading zeros
                // Because exponent field = 0, so effective exponent = 1 - lz_count
                // We apply it here, exponent stored in 10-bit reg.
                // So exponent = 1 - lz_count
                integer lz_a;
                lz_a = leading_zero_count_24(a_mantissa);
                a_mantissa <= a_mantissa << lz_a;
                a_exponent <= 10'd1 - lz_a;
            end
            // For b
            if (b[30:23] == 8'd0 && !b_is_zero && !b_is_nan && !b_is_inf) begin
                integer lz_b;
                lz_b = leading_zero_count_24(b_mantissa);
                b_mantissa <= b_mantissa << lz_b;
                b_exponent <= 10'd1 - lz_b;
            end
            counter <= counter + 3'd1;
        end

        3'd2: begin
            // Special cases detection and handling prior to multiplication
            // NaN if either input is NaN
            // Inf * 0 -> NaN
            special_nan  <= a_is_nan || b_is_nan || ( (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero) );
            // Inf if inputs are infinite and no NaN and no Inf*0
            special_inf  <= (!special_nan) && (a_is_inf || b_is_inf);
            // Zero if inputs zero and no NaN and no Inf*0
            special_zero <= (!special_nan && !special_inf) && (a_is_zero || b_is_zero);
            // If special cases, product mantissa and exponent don't matter
            if (special_nan || special_inf || special_zero) begin
                product <= 50'd0;
                z_exponent <= 10'd0;
                z_mantissa <= 24'd0;
            end else begin
                // Calculate exponent sum minus bias (127)
                // Exponents stored as 10-bit, but real exponent is only 8-bit + bias 127
                z_exponent <= (a_exponent + b_exponent) - 10'd127;
                // Mantissa multiply (24x24) result: 48 bits (<= 50 bits to have room)
                product <= a_mantissa * b_mantissa; // 24x24 multiplication
            end
            counter <= counter + 3'd1;
        end

        3'd3: begin
            if (special_nan || special_inf || special_zero) begin
                // Skip normalization and rounding on special cases
                guard_bit <= 1'b0;
                round_bit <= 1'b0;
                sticky_bit <= 1'b0;
            end else begin
                // Normalize the product
                // The product is 48 bits: product[47:0]
                // Check MSB product[47]
                if (product[47] == 1'b1) begin
                    // Already normalized
                    // No shift, exponent +1
                    z_exponent <= z_exponent + 10'd1;
                    // Mantissa bits: bits [46:24] are mantissa field
                    z_mantissa <= product[46:24];
                    // Extract rounding bits
                    guard_bit <= product[23];
                    round_bit <= product[22];
                    sticky_bit <= (|product[21:0]);
                end else begin
                    // Shift left one bit to normalize
                    product <= product << 1;
                    z_exponent <= z_exponent; // exponent unchanged because we shifted product left
                    z_mantissa <= product[46:24]<<1 | product[23]; // After shift, new mantissa
                    // Because we shifted left, update rounding bits accordingly
                    guard_bit <= product[22];      // originally bit 23 before shift
                    round_bit <= product[21];      // originally bit 22
                    sticky_bit <= (|product[20:0]); // OR of lower bits
                end
            end
            counter <= counter + 3'd1;
        end

        3'd4: begin
            if (special_nan || special_inf || special_zero) begin
                // No rounding for special cases
                rounding_increment <= 1'b0;
                mantissa_overflow <= 1'b0;
            end else begin
                // Round to nearest even: round if guard=1 and (round=1 or sticky=1 or LSB=1)
                rounding_increment <= guard_bit && (round_bit || sticky_bit || z_mantissa[0]);
                {mantissa_overflow, z_mantissa} <= z_mantissa + rounding_increment;
            end
            counter <= counter + 3'd1;
        end

        3'd5: begin
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
                // Normal rounding done, check overflow and underflow
                if (mantissa_overflow) begin
                    // Mantissa overflow shifted exponent by 1 more
                    z_exponent <= z_exponent + 10'd1;
                    z_mantissa <= z_mantissa >> 1;
                end
                // Handle exponent overflow -> infinity
                if (z_exponent >= 10'd255) begin
                    z <= {z_sign, 8'hFF, 23'd0}; // Overflow to infinity
                end else if (z_exponent <= 10'd0) begin
                    // Underflow: possible subnormal or zero
                    // If exponent < -23, underflow to zero
                    if (z_exponent < -10'sd23) begin
                        // Zero output
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Subnormal: shift mantissa right by (1 - exponent)
                        // exponent negative or zero, so shift right by abs(exponent)+1
                        reg [23:0] shifted_mantissa;
                        integer shift_amt;
                        shift_amt = 1 - z_exponent[7:0];
                        shifted_mantissa = z_mantissa >> shift_amt;
                        z <= {z_sign, 8'd0, shifted_mantissa[22:0]};
                    end
                end else begin
                    // Normal result
                    z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                end
            end
            counter <= 3'd0; // Ready for next operation
        end

        default: begin
            counter <= 3'd0;
        end
        endcase
    end
end

endmodule