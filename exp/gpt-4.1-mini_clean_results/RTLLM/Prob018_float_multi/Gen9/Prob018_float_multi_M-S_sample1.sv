module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Constants
    localparam EXP_BIAS = 127;

    // Internal registers
    reg [2:0] counter;

    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_mantissa, b_mantissa; // include implicit leading 1 if normalized
    reg [9:0] z_exp; // 10 bits to allow exponent sum + overflow adjustment

    reg [47:0] product; // 24x24 multiplication result

    reg guard_bit, round_bit, sticky_bit;

    reg nan_a, nan_b, inf_a, inf_b, zero_a, zero_b;

    // Temporary mantissa after normalization and rounding (24 bits)
    reg [23:0] norm_mantissa;

    // Work variables for rounding and normalization
    reg [47:0] shifted_product;
    reg [23:0] rounded_mantissa;
    reg [9:0] rounded_exp;

    // Helper signals
    wire a_is_zero = (a_exp == 8'd0) && (a[22:0] == 23'd0);
    wire b_is_zero = (b_exp == 8'd0) && (b[22:0] == 23'd0);
    wire a_is_inf  = (a_exp == 8'hFF) && (a[22:0] == 23'd0);
    wire b_is_inf  = (b_exp == 8'hFF) && (b[22:0] == 23'd0);
    wire a_is_nan  = (a_exp == 8'hFF) && (a[22:0] != 23'd0);
    wire b_is_nan  = (b_exp == 8'hFF) && (b[22:0] != 23'd0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            a_sign <= 0;
            b_sign <= 0;
            a_exp <= 0;
            b_exp <= 0;
            a_mantissa <= 0;
            b_mantissa <= 0;

            product <= 0;
            z_exp <= 0;
            z_sign <= 0;

            guard_bit <= 0;
            round_bit <= 0;
            sticky_bit <= 0;

            nan_a <= 0; nan_b <= 0;
            inf_a <= 0; inf_b <= 0;
            zero_a <= 0; zero_b <= 0;

            norm_mantissa <= 0;
            rounded_mantissa <= 0;
            rounded_exp <= 0;
            shifted_product <= 0;
        end else begin
            case(counter)
                3'd0: begin
                    // Extract signs, exponents, mantissas, detect special cases
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    nan_a <= a_is_nan;
                    nan_b <= b_is_nan;
                    inf_a <= a_is_inf;
                    inf_b <= b_is_inf;
                    zero_a <= a_is_zero;
                    zero_b <= b_is_zero;

                    // Prepare mantissas with implicit leading 1 for normalized, else zero or denormals with leading 0
                    a_mantissa <= (a_exp == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b_exp == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    z_sign <= a[31] ^ b[31];

                    counter <= 3'd1;
                end

                3'd1: begin
                    // Multiply mantissas
                    product <= a_mantissa * b_mantissa; // 24x24=48 bits

                    // Calculate raw exponent sum (with bias correction)
                    // Use 10 bits to cover possible overflow
                    z_exp <= a_exp + b_exp - EXP_BIAS;

                    counter <= 3'd2;
                end

                3'd2: begin
                    // Normalize product
                    // If MSB of product is 1 (bit 47), shift right by 1 and increment exponent
                    if (product[47]) begin
                        shifted_product <= product;
                        z_exp <= z_exp + 1;
                    end else begin
                        shifted_product <= product << 1;
                        // exponent stays same
                    end

                    counter <= 3'd3;
                end

                3'd3: begin
                    // Extract mantissa, guard, round, sticky bits for rounding
                    norm_mantissa <= shifted_product[46:23]; // top 24 bits (including implicit 1)

                    guard_bit <= shifted_product[22];
                    round_bit <= shifted_product[21];
                    sticky_bit <= |shifted_product[20:0];

                    counter <= 3'd4;
                end

                3'd4: begin
                    // Round to nearest even
                    // round_increment = guard & (round | sticky | LSB)
                    if (guard_bit && (round_bit || sticky_bit || norm_mantissa[0])) begin
                        rounded_mantissa <= norm_mantissa + 1;
                    end else begin
                        rounded_mantissa <= norm_mantissa;
                    end

                    rounded_exp <= z_exp;

                    counter <= 3'd5;
                end

                3'd5: begin
                    // Handle mantissa overflow after rounding
                    if (rounded_mantissa[23]) begin
                        // Mantissa overflowed (carry out)
                        rounded_exp <= rounded_exp + 1;
                        // shift mantissa right by 1
                        rounded_mantissa <= rounded_mantissa >> 1;
                    end

                    counter <= 3'd6;
                end

                3'd6: begin
                    // Handle special cases and finalize output

                    if (nan_a || nan_b) begin
                        // Return quiet NaN: exponent all ones, mantissa MSB=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((inf_a && zero_b) || (inf_b && zero_a)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (inf_a || inf_b) begin
                        // Infinity times non-zero = infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (zero_a || zero_b) begin
                        // Zero times anything = zero
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal result: check overflow and underflow

                        if (rounded_exp >= 10'd255) begin
                            // Overflow -> Infinity
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (rounded_exp <= 0) begin
                            // Underflow -> zero (flush)
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Normal number
                            z <= {z_sign, rounded_exp[7:0], rounded_mantissa[22:0]};
                        end
                    end

                    counter <= 3'd0; // ready for next operation
                end

                default: counter <= 3'd0;
            endcase
        end
    end

endmodule