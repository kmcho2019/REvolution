module float_multi (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] z
);

    // Constants
    localparam EXP_BIAS = 127;
    localparam EXP_MAX  = 8'hFF;
    localparam MANT_WIDTH = 23;

    // Cycle counter: 0 to 5 for each stage
    reg [2:0] counter;

    // Input fields extracted combinationally
    wire a_sign = a[31];
    wire [7:0] a_exp = a[30:23];
    wire [22:0] a_frac = a[22:0];

    wire b_sign = b[31];
    wire [7:0] b_exp = b[30:23];
    wire [22:0] b_frac = b[22:0];

    // Special cases combinational
    wire a_is_nan  = (a_exp == EXP_MAX) && (a_frac != 0);
    wire b_is_nan  = (b_exp == EXP_MAX) && (b_frac != 0);
    wire a_is_inf  = (a_exp == EXP_MAX) && (a_frac == 0);
    wire b_is_inf  = (b_exp == EXP_MAX) && (b_frac == 0);
    wire a_is_zero = (a_exp == 0) && (a_frac == 0);
    wire b_is_zero = (b_exp == 0) && (b_frac == 0);

    // Registered inputs latched at counter==0
    reg a_sign_r, b_sign_r, z_sign_r;
    reg [7:0] a_exp_r, b_exp_r;
    reg [22:0] a_frac_r, b_frac_r;
    reg a_is_nan_r, b_is_nan_r;
    reg a_is_inf_r, b_is_inf_r;
    reg a_is_zero_r, b_is_zero_r;

    // Mantissas with implicit leading 1 or 0 for denormals
    reg [23:0] a_mantissa, b_mantissa;

    // Intermediate product of mantissas (24x24=48 bits)
    reg [47:0] product;

    // Exponent sum (extended width to handle overflow)
    reg [9:0] exp_sum;

    // Normalized mantissa and exponent adjustment
    reg [47:0] norm_mantissa;
    reg [9:0] norm_exponent;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and exponent
    reg [24:0] rounded_mantissa; // 25 bits to detect overflow
    reg [9:0] rounded_exponent;

    // Special flags for output stage
    reg special_nan, special_inf, special_zero;

    // Sticky bit calculation helper
    function sticky_or;
        input [19:0] bits;
        integer i;
        begin
            sticky_or = 0;
            for (i = 0; i < 20; i = i + 1) begin
                if (bits[i]) sticky_or = 1;
            end
        end
    endfunction

    // Sequential logic for multi-cycle operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            a_sign_r <= 1'b0;
            b_sign_r <= 1'b0;
            z_sign_r <= 1'b0;
            a_exp_r <= 8'd0;
            b_exp_r <= 8'd0;
            a_frac_r <= 23'd0;
            b_frac_r <= 23'd0;
            a_is_nan_r <= 1'b0;
            b_is_nan_r <= 1'b0;
            a_is_inf_r <= 1'b0;
            b_is_inf_r <= 1'b0;
            a_is_zero_r <= 1'b0;
            b_is_zero_r <= 1'b0;
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            product <= 48'd0;
            exp_sum <= 10'd0;
            norm_mantissa <= 48'd0;
            norm_exponent <= 10'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
            rounded_mantissa <= 25'd0;
            rounded_exponent <= 10'd0;
            special_nan <= 1'b0;
            special_inf <= 1'b0;
            special_zero <= 1'b0;
        end else begin
            case (counter)
                3'd0: begin
                    // Capture and decode inputs
                    a_sign_r <= a_sign;
                    b_sign_r <= b_sign;
                    z_sign_r <= a_sign ^ b_sign;

                    a_exp_r <= a_exp;
                    b_exp_r <= b_exp;
                    a_frac_r <= a_frac;
                    b_frac_r <= b_frac;
                    a_is_nan_r <= a_is_nan;
                    b_is_nan_r <= b_is_nan;
                    a_is_inf_r <= a_is_inf;
                    b_is_inf_r <= b_is_inf;
                    a_is_zero_r <= a_is_zero;
                    b_is_zero_r <= b_is_zero;

                    // Prepare mantissas: if exponent != 0, implicit leading 1, else 0 (denormals)
                    a_mantissa <= (a_exp != 0) ? {1'b1, a_frac} : {1'b0, a_frac};
                    b_mantissa <= (b_exp != 0) ? {1'b1, b_frac} : {1'b0, b_frac};

                    // Clear special flags
                    special_nan <= 1'b0;
                    special_inf <= 1'b0;
                    special_zero <= 1'b0;
                end

                3'd1: begin
                    // Special cases detection and handling
                    if (a_is_nan_r || b_is_nan_r) begin
                        special_nan <= 1'b1;
                    end else if ((a_is_inf_r && b_is_zero_r) || (b_is_inf_r && a_is_zero_r)) begin
                        // Inf * 0 = NaN
                        special_nan <= 1'b1;
                    end else if (a_is_inf_r || b_is_inf_r) begin
                        special_inf <= 1'b1;
                    end else if (a_is_zero_r || b_is_zero_r) begin
                        special_zero <= 1'b1;
                    end else begin
                        special_nan <= 1'b0;
                        special_inf <= 1'b0;
                        special_zero <= 1'b0;

                        // Exponent sum: a_exp + b_exp - bias
                        // For denormals exponent == 0 considered as 1-bias for exponent = -126 per IEEE754
                        // But here we leave as is, and mantissa without implicit 1 means it's denormal
                        exp_sum <= a_exp_r + b_exp_r - EXP_BIAS;
                    end
                end

                3'd2: begin
                    // Mantissa multiplication (24x24=48 bits)
                    // Only when not special case
                    if (!(special_nan || special_inf || special_zero)) begin
                        product <= a_mantissa * b_mantissa;
                    end
                end

                3'd3: begin
                    if (special_nan || special_inf || special_zero) begin
                        // Nothing to do here
                        norm_mantissa <= 48'd0;
                        norm_exponent <= 10'd0;
                    end else begin
                        // Normalize product mantissa and adjust exponent
                        // The product is 48 bits: possible leading bits at [47] or [46] or lower for denormals

                        if (product[47]) begin
                            // MSB 1 at bit 47, normalized, increase exponent by 1
                            norm_mantissa <= product;
                            norm_exponent <= exp_sum + 1;
                        end else if (product[46]) begin
                            // MSB at bit 46, shift left by 1 and exponent unchanged
                            norm_mantissa <= product << 1;
                            norm_exponent <= exp_sum;
                        end else begin
                            // Denormal result, shift left until MSB=1 or exponent underflow
                            // Count leading zeros starting from bit 46 downward

                            integer shift_count;
                            reg [47:0] shifted;
                            shift_count = 0;
                            shifted = product;

                            // Check bits 46 downto 0
                            while (shift_count < 47 && shifted[47] == 0) begin
                                shifted = shifted << 1;
                                shift_count = shift_count + 1;
                            end
                            norm_mantissa <= shifted;
                            norm_exponent <= exp_sum - shift_count;
                        end
                    end
                end

                3'd4: begin
                    if (special_nan || special_inf || special_zero) begin
                        // No rounding needed for special cases
                        rounded_mantissa <= 25'd0;
                        rounded_exponent <= 10'd0;
                        guard_bit <= 1'b0;
                        round_bit <= 1'b0;
                        sticky_bit <= 1'b0;
                    end else begin
                        // Extract rounding bits for round-to-nearest-even:
                        // After normalization, mantissa is in norm_mantissa[47:0]
                        // Use bits [46:24] as mantissa (23 bits fraction + 1 implicit =24 bits)
                        // Guard bit = bit 23
                        // Round bit = bit 22
                        // Sticky bit = OR of bits 21 down to 0

                        reg [23:0] mant24;
                        reg gb, rb, sb;
                        integer i;
                        reg sticky;

                        if (norm_mantissa[47]) begin
                            // Normalized with leading 1 at bit 47
                            mant24 = norm_mantissa[46:23];
                            gb = norm_mantissa[22];
                            rb = norm_mantissa[21];
                            sticky = 0;
                            for (i = 0; i <= 20; i = i + 1) begin
                                if (norm_mantissa[i]) sticky = 1;
                            end
                            sb = sticky;
                        end else begin
                            // Leading 1 should be at bit 46 (if denormal, more shifting done in normalization)
                            // But here norm_mantissa[47] == 0 means no leading one, mantissa is shifted accordingly.
                            mant24 = norm_mantissa[45:22];
                            gb = norm_mantissa[21];
                            rb = norm_mantissa[20];
                            sticky = 0;
                            for (i = 0; i <= 19; i = i + 1) begin
                                if (norm_mantissa[i]) sticky = 1;
                            end
                            sb = sticky;
                        end

                        // Set rounding bits
                        guard_bit <= gb;
                        round_bit <= rb;
                        sticky_bit <= sb;

                        // Round-to-nearest-even
                        // Rounded mantissa = mant24 + 1 if (guard & (round|sticky|lsb))
                        // LSB is mant24[0]
                        rounded_mantissa[24:1] <= mant24;
                        rounded_mantissa[0] <= 1'b0; // for rounding addition safety

                        rounded_exponent <= norm_exponent;

                        // Perform rounding in next clock cycle to avoid combinational complexity,
                        // but here we implement combinationally using non-blocking assignments:
                        if (gb && (rb || sb || mant24[0])) begin
                            // round up
                            {rounded_exponent, rounded_mantissa[24:0]} <= {norm_exponent, mant24} + 1;
                        end else begin
                            {rounded_exponent, rounded_mantissa[24:0]} <= {norm_exponent, mant24};
                        end

                        // Check overflow of mantissa after rounding
                        if (rounded_mantissa[24]) begin
                            // Mantissa overflowed to 25 bits -> shift right by 1 and increment exponent
                            rounded_mantissa <= rounded_mantissa >> 1;
                            rounded_exponent <= rounded_exponent + 1;
                        end
                    end
                end

                3'd5: begin
                    // Output packing and handling special cases

                    if (special_nan) begin
                        // Quiet NaN: sign=0, exp=all 1's, MSB of fraction=1 to indicate quiet NaN, rest zero
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (special_inf) begin
                        // Infinity with correct sign
                        z <= {z_sign_r, 8'hFF, 23'd0};
                    end else if (special_zero) begin
                        // Zero with correct sign
                        z <= {z_sign_r, 31'd0};
                    end else begin
                        // Normal number output with exponent overflow/underflow checks
                        if (rounded_exponent >= EXP_MAX) begin
                            // Overflow => infinity
                            z <= {z_sign_r, 8'hFF, 23'd0};
                        end else if (rounded_exponent <= 0) begin
                            // Underflow => zero (subnormals not supported)
                            z <= {z_sign_r, 31'd0};
                        end else begin
                            // Normalized result
                            // rounded_mantissa[23:1] are fraction bits, [24] implicit bit dropped
                            z <= {z_sign_r, rounded_exponent[7:0], rounded_mantissa[22:0]};
                        end
                    end
                end

                default: begin
                    // Should never reach here, just increment counter safely
                end
            endcase

            // Increment or reset counter
            if (counter == 3'd5)
                counter <= 3'd0;
            else
                counter <= counter + 3'd1;
        end
    end

endmodule