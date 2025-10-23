module float_multi(
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);

    // IEEE-754 parameters
    localparam EXP_BIAS = 127;

    // Cycle counter for sequencing stages: 0,1,2 then wrap
    reg [2:0] counter;

    // Stage registers for inputs and control signals
    reg        a_sign, b_sign;
    reg [7:0]  a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Special cases
    reg a_is_zero, a_is_inf, a_is_nan;
    reg b_is_zero, b_is_inf, b_is_nan;

    // Operand mantissas including implicit leading 1 or zero for denormals
    reg [23:0] a_mantissa, b_mantissa;

    // Multiplier outputs and intermediates (combinational)
    reg [47:0] product;       // 24x24 multiplication result
    reg [9:0]  exp_sum;       // Exponent sum with extra bit for overflow
    reg        sign_z;        // Result sign

    // Normalization signals
    reg        product_msb;   // Indicates if product needs right shift (normalization)
    reg [47:0] norm_product;  // Normalized product
    reg [9:0]  norm_exp;      // Adjusted exponent after normalization

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounded mantissa and final exponent
    reg [24:0] mantissa_rounded;
    reg [9:0]  exp_rounded;

    // Sticky bit generation: OR of bits below round_bit position
    function sticky_bit_fn;
        input [20:0] bits; // sticky bits range (up to 21 bits)
        integer i;
        begin
            sticky_bit_fn = 1'b0;
            for (i=0; i < 21; i=i+1) begin
                sticky_bit_fn = sticky_bit_fn | bits[i];
            end
        end
    endfunction

    // Special case flags registered each cycle
    reg a_is_zero_r, a_is_inf_r, a_is_nan_r;
    reg b_is_zero_r, b_is_inf_r, b_is_nan_r;
    reg sign_z_r;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Clear registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_is_zero <= 1'b0; a_is_inf <= 1'b0; a_is_nan <= 1'b0;
            b_is_zero <= 1'b0; b_is_inf <= 1'b0; b_is_nan <= 1'b0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            product <= 48'd0;
            exp_sum <= 10'd0;
            sign_z <= 1'b0;
            product_msb <= 1'b0;
            norm_product <= 48'd0;
            norm_exp <= 10'd0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            mantissa_rounded <= 25'd0;
            exp_rounded <= 10'd0;

            a_is_zero_r <= 1'b0; a_is_inf_r <= 1'b0; a_is_nan_r <= 1'b0;
            b_is_zero_r <= 1'b0; b_is_inf_r <= 1'b0; b_is_nan_r <= 1'b0;
            sign_z_r <= 1'b0;

        end else begin
            case(counter)
                3'd0: begin
                    // Extract inputs, special cases and mantissas
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                    a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                    a_is_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_is_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Build mantissa with implicit leading 1 if normal
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                end

                3'd1: begin
                    // Perform multiplication of mantissas and exponent addition
                    product <= a_mantissa * b_mantissa; // 24x24 -> 48 bits
                    exp_sum <= a_exp + b_exp - EXP_BIAS;
                    sign_z <= a_sign ^ b_sign;

                    // Save special case flags for pipeline
                    a_is_zero_r <= a_is_zero;
                    b_is_zero_r <= b_is_zero;
                    a_is_inf_r <= a_is_inf;
                    b_is_inf_r <= b_is_inf;
                    a_is_nan_r <= a_is_nan;
                    b_is_nan_r <= b_is_nan;
                    sign_z_r <= a_sign ^ b_sign;
                end

                3'd2: begin
                    // Normalization
                    product_msb <= product[47];
                    if (product[47]) begin
                        norm_product <= product;
                        norm_exp <= exp_sum + 10'd1;
                    end else begin
                        norm_product <= product << 1; // shift left to normalize leading 1
                        norm_exp <= exp_sum;
                    end

                    // Extract rounding bits: guard, round and sticky
                    // Positions depend on normalization shift
                    // Guard bit is bit 23 (one below mantissa LSB), round bit is bit 22, sticky is OR of bits 0..21
                    if (product[47]) begin
                        // MSB=1 means product is already normalized (bit47 is implicit 1)
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= sticky_bit_fn(product[21:0]);
                    end else begin
                        // After shift left by 1
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= sticky_bit_fn(product[20:0]);
                    end

                    // Round mantissa
                    // Mantissa 24 bits + 1 bit carry -> 25 bits total for rounding
                    mantissa_rounded <= norm_product[46:23] + 
                                        ((guard_bit & (round_bit | sticky_bit | norm_product[23])) ? 25'd1 : 25'd0);

                    // Adjust exponent if rounding caused overflow of mantissa
                    if (mantissa_rounded[24]) begin
                        exp_rounded <= norm_exp + 10'd1;
                    end else begin
                        exp_rounded <= norm_exp;
                    end
                end

                3'd3: begin
                    // Output generation: Handle special cases and final packaging
                    // Clamp exponent and handle underflow/overflow
                    if (a_is_nan_r || b_is_nan_r) begin
                        // Return Quiet NaN: sign=0, exp=all 1s, mantissa MSB=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_is_inf_r && b_is_zero_r) || (b_is_inf_r && a_is_zero_r)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_is_inf_r || b_is_inf_r) begin
                        // Inf times finite != 0 or Inf times Inf = Inf
                        z <= {sign_z_r, 8'hFF, 23'd0};
                    end else if (a_is_zero_r || b_is_zero_r) begin
                        // Zero times anything = zero
                        z <= {sign_z_r, 31'd0};
                    end else begin
                        // Normal number output
                        // Check overflow
                        if (exp_rounded >= 10'd255) begin
                            // Overflow -> infinity
                            z <= {sign_z_r, 8'hFF, 23'd0};
                        end else if (exp_rounded <= 10'd0) begin
                            // Underflow -> zero (flush to zero, no subnormals)
                            z <= {sign_z_r, 31'd0};
                        end else begin
                            // Normalized value
                            // Select mantissa bits: If rounding overflowed mantissa, shift right 1 bit
                            if (mantissa_rounded[24]) begin
                                // Mantissa shifted right by 1 (discard LSB)
                                z <= {sign_z_r, exp_rounded[7:0], mantissa_rounded[23:1]};
                            end else begin
                                z <= {sign_z_r, exp_rounded[7:0], mantissa_rounded[22:0]};
                            end
                        end
                    end
                end

            endcase

            // Advance counter modulo 4 to cycle through states 0-3
            counter <= (counter == 3'd3) ? 3'd0 : counter + 3'd1;
        end
    end

endmodule