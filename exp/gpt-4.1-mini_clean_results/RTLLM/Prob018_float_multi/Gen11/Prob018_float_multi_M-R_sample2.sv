module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Constants
    localparam EXP_BIAS = 127;

    // Internal registers for input fields and intermediate values
    reg [2:0]   counter;

    reg         a_sign, b_sign, z_sign;
    reg [9:0]   a_exponent, b_exponent, z_exponent;  // Use 10 bits for signed arithmetic convenience
    reg [23:0]  a_mantissa, b_mantissa, z_mantissa;
    reg [49:0]  product;  // 24x24 multiplication result (48 bits) stored in 50 bits for shifts

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Special cases flags
    reg a_is_zero, a_is_inf, a_is_nan;
    reg b_is_zero, b_is_inf, b_is_nan;
    reg inf_times_zero;

    // Temporary signals
    wire product_msb;

    // Reset and counter increment logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            a_sign <= 1'b0; b_sign <= 1'b0; z_sign <= 1'b0;
            a_exponent <= 10'd0; b_exponent <= 10'd0; z_exponent <= 10'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0; z_mantissa <= 24'd0;
            product <= 50'd0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            a_is_zero <= 1'b0; a_is_inf <= 1'b0; a_is_nan <= 1'b0;
            b_is_zero <= 1'b0; b_is_inf <= 1'b0; b_is_nan <= 1'b0;
            inf_times_zero <= 1'b0;
        end else begin
            case (counter)
                3'd0: begin
                    // Extract sign, exponent, mantissa with implicit bit
                    a_sign <= a[31];
                    b_sign <= b[31];
                    z_sign <= a[31] ^ b[31];

                    a_exponent <= {2'b00, a[30:23]};  // extend to 10 bits (upper bits zero)
                    b_exponent <= {2'b00, b[30:23]};

                    // Detect special cases for a
                    a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    a_is_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    a_is_nan  <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);

                    // Detect special cases for b
                    b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);
                    b_is_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
                    b_is_nan  <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Determine mantissas (with implicit leading 1 if normal)
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                    
                    // Check inf * zero special invalid case
                    inf_times_zero <= ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero));

                    // Reset intermediate regs
                    product <= 50'd0;
                    guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
                    z_exponent <= 10'd0;
                    z_mantissa <= 24'd0;

                    z <= 32'd0;
                    counter <= counter + 1'b1;
                end

                3'd1: begin
                    // Handle special cases and do mantissa multiplication
                    if (a_is_nan || b_is_nan || inf_times_zero) begin
                        // No multiplication needed, output NaN later
                        // Just move forward
                    end else if (a_is_inf || b_is_inf || a_is_zero || b_is_zero) begin
                        // For these cases, multiplication handled in final step
                    end else begin
                        // Perform mantissa multiplication (24x24 = 48 bits)
                        product <= a_mantissa * b_mantissa;  // result 48 bits in lower bits of 50-bit reg
                    end
                    counter <= counter + 1'b1;
                end

                3'd2: begin
                    // Normalization step: check MSB of product and adjust exponent

                    // Calculate raw exponent sum minus bias:
                    // exp_sum = a_exp + b_exp - EXP_BIAS (bias is 127)
                    // Use signed arithmetic in 10 bits with offset:
                    integer exp_sum_int;
                    exp_sum_int = (a_exponent + b_exponent) - EXP_BIAS;

                    // Check MSB of product (bit 47)
                    if (product[47]) begin
                        // product already normalized, exponent + 1 because of leading 1 at bit 47
                        z_exponent <= exp_sum_int + 1;
                        z_mantissa <= product[47:24];  // take top 24 bits (including implicit 1)
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // shift product left by 1, decrement exponent by 1
                        z_exponent <= exp_sum_int;
                        z_mantissa <= product[46:23]; // shifted left by one bit is equivalent to taking [46:23]
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end
                    counter <= counter + 1'b1;
                end

                3'd3: begin
                    // Rounding and final adjustment

                    // Round to nearest even
                    // If guard bit = 1 and (round bit or sticky bit or lsb of mantissa is 1), then round up
                    if (guard_bit && (round_bit || sticky_bit || z_mantissa[0])) begin
                        {z_sign, z_exponent, z_mantissa} <= round_up(z_sign, z_exponent, z_mantissa);
                    end

                    // Check overflow and underflow after rounding
                    if (z_exponent > 254) begin
                        // Overflow -> infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (z_exponent < 1) begin
                        // Underflow -> zero (flush to zero)
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal result
                        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                    end

                    // Handle special cases overriding normal output
                    if (a_is_nan || b_is_nan || inf_times_zero) begin
                        // Return canonical quiet NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_is_inf || b_is_inf) begin
                        if (a_is_zero || b_is_zero) begin
                            // Inf * 0 already handled as NaN above (inf_times_zero)
                            // so no case here
                        end else begin
                            // Inf * non-zero = inf
                            z <= {z_sign, 8'hFF, 23'd0};
                        end
                    end else if (a_is_zero || b_is_zero) begin
                        // zero * anything = zero
                        z <= {z_sign, 31'd0};
                    end

                    // Reset for next calculation
                    counter <= 3'd0;
                end

                default: begin
                    counter <= 3'd0;
                    z <= 32'd0;
                end
            endcase
        end
    end

    // Function to round mantissa and adjust exponent when rounding causes overflow
    // Takes sign, exponent and mantissa inputs, returns adjusted versions
    function automatic [56:0] round_up; // [56:0] = {sign, exponent(9:0), mantissa(23:0)}
        input sign_in;
        input [9:0] exponent_in;
        input [23:0] mantissa_in;
        reg [23:0] mantissa_rounded;
        reg [9:0] exponent_rounded;
        begin
            mantissa_rounded = mantissa_in + 1'b1;
            exponent_rounded = exponent_in;
            if (mantissa_rounded[23]) begin
                // mantissa overflowed from 24 bits, shift right 1 and increment exponent
                mantissa_rounded = mantissa_rounded >> 1;
                exponent_rounded = exponent_rounded + 1;
            end
            round_up = {sign_in, exponent_rounded, mantissa_rounded};
        end
    endfunction

endmodule