module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Internal parameters
    localparam EXP_BIAS = 127;

    // Operation cycle counter
    reg [2:0] counter;

    // Internal registers to hold inputs fields and intermediate results
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exp, b_exp;
    reg [7:0] z_exp;
    reg [22:0] a_frac, b_frac;

    reg a_is_zero, b_is_zero;
    reg a_is_inf, b_is_inf;
    reg a_is_nan, b_is_nan;

    reg [23:0] a_mantissa; // 1-bit implicit + 23 bits fraction
    reg [23:0] b_mantissa;

    reg [47:0] product; // 24 x 24 multiply -> 48 bits

    reg [9:0] exp_sum; // 10 bits to hold intermediate exponent sum

    reg [23:0] norm_mantissa; // normalized mantissa
    reg [9:0] norm_exp;       // normalized exponent

    reg guard_bit, round_bit, sticky_bit;

    reg round_increment;

    reg [24:0] rounded_mantissa; // 25 bits (including possible carry from rounding)

    // cycle counter: sequences from 0 to 3 then holds at 3
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
        end else begin
            if(counter < 3)
                counter <= counter + 1'b1;
            // else stay at 3 (output cycle)
        end
    end

    // Stage 0: Extract sign, exponent, fraction, detect special cases; compute initial mantissas
    always @(posedge clk) begin
        if (rst) begin
            a_sign <= 0; b_sign <= 0;
            a_exp <= 0; b_exp <= 0;
            a_frac <= 0; b_frac <= 0;
            a_is_zero <= 0; b_is_zero <= 0;
            a_is_inf <= 0; b_is_inf <= 0;
            a_is_nan <= 0; b_is_nan <= 0;
            a_mantissa <= 0; b_mantissa <= 0;
            z_sign <= 0;
        end else if (counter == 3'd0) begin
            // Input fields extraction
            a_sign <= a[31];
            b_sign <= b[31];

            a_exp <= a[30:23];
            b_exp <= b[30:23];

            a_frac <= a[22:0];
            b_frac <= b[22:0];

            // Special cases
            a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
            b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

            a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
            b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

            a_is_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
            b_is_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

            // Prepare mantissas with implicit leading 1 for normalized numbers or 0 for denormals
            a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

            // Calculate sign of product
            z_sign <= a[31] ^ b[31];
        end
    end

    // Stage 1: Mantissa multiply, exponent add
    always @(posedge clk) begin
        if (rst) begin
            product <= 48'd0;
            exp_sum <= 10'd0;
        end else if (counter == 3'd1) begin
            // 24x24 multiplication
            product <= a_mantissa * b_mantissa;

            // exponent addition minus bias
            // Both exponents are 8-bit: 0..255
            exp_sum <= a_exp + b_exp - EXP_BIAS;

            // z_sign maintained from previous cycle already
        end
    end

    // Stage 2: Normalization and rounding bits extraction
    always @(posedge clk) begin
        if (rst) begin
            norm_mantissa <= 24'd0;
            norm_exp <= 10'd0;
            guard_bit <= 0;
            round_bit <= 0;
            sticky_bit <= 0;
        end else if (counter == 3'd2) begin
            // Normalize mantissa and adjust exponent
            if (product[47]) begin
                // Leading 1 at bit 47 => product >= 2.0, shift right by 1, increment exponent
                norm_mantissa <= product[47:24]; // top 24 bits
                norm_exp <= exp_sum + 10'd1;

                // Extract rounding bits from lower 24 bits:
                guard_bit <= product[23];
                round_bit <= product[22];
                sticky_bit <= |product[21:0];
            end else begin
                // Leading one at bit 46 or below, no shift exponent
                norm_mantissa <= product[46:23];
                norm_exp <= exp_sum;

                guard_bit <= product[22];
                round_bit <= product[21];
                sticky_bit <= |product[20:0];
            end
        end
    end

    // Stage 3: Rounding, final adjustment and output formatting
    always @(posedge clk) begin
        if (rst) begin
            z <= 32'd0;
            z_exp <= 8'd0;
        end else if (counter == 3'd3) begin
            // Round to nearest even
            round_increment <= guard_bit && (round_bit | sticky_bit | norm_mantissa[0]);

            if (round_increment)
                rounded_mantissa <= {1'b0, norm_mantissa} + 25'd1;
            else
                rounded_mantissa <= {1'b0, norm_mantissa};

            // Adjust exponent if rounding caused overflow of mantissa (carry out)
            if (rounded_mantissa[24]) begin
                z_exp <= norm_exp[7:0] + 8'd1;
                z_mantissa <= rounded_mantissa[24:2]; // shifted right by 1
            end else begin
                z_exp <= norm_exp[7:0];
                z_mantissa <= rounded_mantissa[22:0];
            end

            // Special cases handling
            if (a_is_nan || b_is_nan) begin
                // Quiet NaN: exponent=0xFF, MSB mantissa=1
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                // Inf*0 = NaN
                z <= {1'b0, 8'hFF, 1'b1, 22'd0};
            end else if (a_is_inf || b_is_inf) begin
                // Inf times non-zero = Inf
                z <= {z_sign, 8'hFF, 23'd0};
            end else if (a_is_zero || b_is_zero) begin
                // Zero times anything = zero (with correct sign)
                z <= {z_sign, 31'd0};
            end else begin
                // Normal numbers
                if (z_exp >= 8'hFF) begin
                    // Overflow -> Inf
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (z_exp <= 0) begin
                    // Underflow -> zero (flush to zero)
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normal result
                    z <= {z_sign, z_exp, z_mantissa};
                end
            end
        end
    end

    // Internal storage for mantissa after rounding and exponent for final output
    reg [22:0] z_mantissa;

endmodule