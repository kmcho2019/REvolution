module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    localparam EXP_BIAS = 127;

    reg [2:0] counter;

    // Internal signals
    reg         a_sign, b_sign, z_sign;
    reg [9:0]   a_exponent, b_exponent, z_exponent;
    reg [23:0]  a_mantissa, b_mantissa, z_mantissa;
    reg [49:0]  product;
    reg guard_bit, round_bit, sticky;

    // Special case flags
    reg a_is_zero, b_is_zero;
    reg a_is_inf, b_is_inf;
    reg a_is_nan, b_is_nan;

    // Intermediate normalized mantissa and exponent after multiplication
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;

    // Rounding increment flag
    reg round_inc;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Clear intermediate registers
            a_sign <= 1'b0; b_sign <= 1'b0; z_sign <= 1'b0;
            a_exponent <= 10'd0; b_exponent <= 10'd0; z_exponent <= 10'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0; z_mantissa <= 24'd0;
            product <= 50'd0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky <= 1'b0;

            a_is_zero <= 1'b0; b_is_zero <= 1'b0;
            a_is_inf <= 1'b0;  b_is_inf <= 1'b0;
            a_is_nan <= 1'b0;  b_is_nan <= 1'b0;

            norm_mantissa <= 24'd0;
            norm_exponent <= 10'd0;
            round_inc <= 1'b0;

        end else begin
            case (counter)
                3'd0: begin
                    // Cycle 0: Extract fields and identify special cases
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= {2'b00, a[30:23]}; // widen to 10 bits
                    b_exponent <= {2'b00, b[30:23]};
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    a_is_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_is_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                    a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                    a_is_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_is_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    z_sign <= a[31] ^ b[31];

                    // Clear output to zero for now
                    z <= 32'd0;

                    counter <= counter + 1;
                end

                3'd1: begin
                    // Cycle 1: Multiply mantissas and add exponents (with bias correction)
                    product <= a_mantissa * b_mantissa; // 24x24=48-bit product fits in 50 bits reg

                    // exponent sum = a_exp + b_exp - bias
                    // a_exponent and b_exponent are zero-extended 10-bit numbers
                    // so sum can be up to ~510
                    z_exponent <= a_exponent + b_exponent - EXP_BIAS;

                    counter <= counter + 1;
                end

                3'd2: begin
                    // Cycle 2: Normalize product and extract rounding bits

                    // Check if MSB of product[49] is 1
                    if (product[49]) begin
                        // Leading 1 at bit 49: shift right by 1, increment exponent
                        norm_mantissa <= product[49:26]; // 24 bits with leading 1
                        norm_exponent <= z_exponent + 1;

                        guard_bit <= product[25];
                        round_bit <= product[24];
                        sticky <= |product[23:0];
                    end else begin
                        // Leading 1 at bit 48 or below: no shift
                        norm_mantissa <= product[48:25]; // 24 bits
                        norm_exponent <= z_exponent;

                        guard_bit <= product[24];
                        round_bit <= product[23];
                        sticky <= |product[22:0];
                    end

                    counter <= counter + 1;
                end

                3'd3: begin
                    // Cycle 3: Perform rounding and assemble final output

                    // Determine if rounding increment needed (round to nearest even)
                    round_inc <= guard_bit && (round_bit || sticky || norm_mantissa[0]);

                    // Add rounding increment to mantissa
                    {z_mantissa, } <= norm_mantissa + round_inc;

                    // Adjust exponent if mantissa overflowed after rounding
                    if (round_inc && (norm_mantissa == 24'hFFFFFF)) begin
                        // Mantissa overflow after rounding, shift right by 1, increment exponent
                        z_exponent <= norm_exponent + 1;
                        z_mantissa <= 24'h800000; // implicit leading one with all zeros after
                    end else begin
                        z_exponent <= norm_exponent;
                    end

                    // Handle special cases and assemble output
                    if (a_is_nan || b_is_nan) begin
                        // Return quiet NaN: sign=0, exp=all ones, mantissa MSB=1 (quiet NaN indicator)
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_is_inf || b_is_inf) begin
                        // Inf times non-zero = Inf
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (a_is_zero || b_is_zero) begin
                        // Zero times anything = zero
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal number - check exponent overflow/underflow
                        if (z_exponent >= 10'd255) begin
                            // Overflow => Inf
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (z_exponent <= 10'd0) begin
                            // Underflow => zero (flush to zero)
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Normalized number, assemble output
                            z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                        end
                    end

                    counter <= 3'd0; // Wrap around for next operation
                end

                default: counter <= 3'd0;
            endcase
        end
    end

endmodule