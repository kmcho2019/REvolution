module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Internal registers and wires
    reg [2:0] counter;

    // Extracted fields
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [7:0] z_exponent;
    reg [23:0] a_mantissa, b_mantissa; // 24 bits with implicit leading 1
    reg [23:0] z_mantissa;

    // Intermediate values
    reg [47:0] product;       // 24x24 mantissa multiplication result
    reg [9:0] exponent_sum;   // Extended exponent sum for overflow handling

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Special flags
    reg a_is_nan, b_is_nan;
    reg a_is_inf, b_is_inf;
    reg a_is_zero, b_is_zero;
    reg special_case; // Flag to indicate special case handling done

    // Constants
    localparam EXP_BIAS = 127;

    // Stage registers for output
    reg [31:0] result_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            // Clear all internal registers
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            z_sign <= 1'b0;
            a_exponent <= 8'd0;
            b_exponent <= 8'd0;
            z_exponent <= 8'd0;
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            z_mantissa <= 24'd0;
            product <= 48'd0;
            exponent_sum <= 10'd0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;
            a_is_nan <= 1'b0;
            b_is_nan <= 1'b0;
            a_is_inf <= 1'b0;
            b_is_inf <= 1'b0;
            a_is_zero <= 1'b0;
            b_is_zero <= 1'b0;
            special_case <= 1'b0;
            result_reg <= 32'd0;
        end else begin
            case (counter)
                3'd0: begin
                    // Extract inputs fields
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];

                    // Detect special cases for a
                    a_is_zero <= (a[30:0] == 31'd0);
                    a_is_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    a_is_nan  <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    // Mantissa with implicit leading 1 for normals
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};

                    // Detect special cases for b
                    b_is_zero <= (b[30:0] == 31'd0);
                    b_is_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);
                    b_is_nan  <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    special_case <= 1'b0; // clear special flag
                    z <= 32'd0; // clear output until ready

                    counter <= 3'd1;
                end

                3'd1: begin
                    // Handle special cases
                    // NaN if either input is NaN
                    if (a_is_nan || b_is_nan) begin
                        // quiet NaN: sign=0, exp=255, mantissa!=0 (set MSB of mantissa)
                        result_reg <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        special_case <= 1'b1;
                    end
                    // Inf * 0 => NaN
                    else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        result_reg <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        special_case <= 1'b1;
                    end
                    // Inf * normal => Inf
                    else if (a_is_inf || b_is_inf) begin
                        z_sign <= a_sign ^ b_sign;
                        result_reg <= {a_sign ^ b_sign, 8'hFF, 23'd0};
                        special_case <= 1'b1;
                    end
                    // 0 * anything => 0
                    else if (a_is_zero || b_is_zero) begin
                        z_sign <= a_sign ^ b_sign;
                        result_reg <= {a_sign ^ b_sign, 31'd0};
                        special_case <= 1'b1;
                    end else begin
                        // Normal multiplication path
                        // Multiply mantissas 24x24 = 48-bit product
                        product <= a_mantissa * b_mantissa;
                        // Sum exponents and subtract bias
                        exponent_sum <= a_exponent + b_exponent - EXP_BIAS;
                        // Calculate result sign
                        z_sign <= a_sign ^ b_sign;
                    end
                    counter <= 3'd2;
                end

                3'd2: begin
                    if (special_case) begin
                        // Output special case result immediately
                        z <= result_reg;
                        counter <= 3'd0; // ready for next operation
                    end else begin
                        // Normalize product
                        // If product[47]==1, shift right 1 and increment exponent
                        if (product[47] == 1'b1) begin
                            product <= product >> 1;
                            exponent_sum <= exponent_sum + 1;
                        end
                        counter <= 3'd3;
                    end
                end

                3'd3: begin
                    if (special_case) begin
                        // Already output special case
                        counter <= 3'd0;
                    end else begin
                        // Extract mantissa bits and rounding bits
                        // Mantissa: bits 46:23 (24 bits)
                        z_mantissa <= product[46:23];

                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];

                        z_exponent <= exponent_sum[7:0]; // use lower 8 bits for exponent now

                        counter <= 3'd4;
                    end
                end

                3'd4: begin
                    if (special_case) begin
                        // Already output special case
                        counter <= 3'd0;
                    end else begin
                        // Round to nearest even
                        if (guard_bit && (round_bit | sticky_bit | z_mantissa[0])) begin
                            {z_exponent, z_mantissa} <= {z_exponent, z_mantissa} + 1'b1;
                            // Check mantissa overflow: if bit 24 set after increment
                            if (z_mantissa[23] == 1'b0) begin
                                // No overflow in mantissa top bit, no exponent increment needed
                            end else begin
                                // Mantissa overflow: shift right by 1, increment exponent
                                z_mantissa <= z_mantissa >> 1;
                                z_exponent <= z_exponent + 1'b1;
                            end
                        end

                        // Handle exponent overflow/underflow
                        if (z_exponent >= 8'hFF) begin
                            // Overflow to infinity
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (z_exponent == 8'd0) begin
                            // Underflow to zero (flush to zero)
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Normal result assembly
                            // Exponent + mantissa (exclude implicit 1)
                            z <= {z_sign, z_exponent, z_mantissa[22:0]};
                        end
                        counter <= 3'd0;
                    end
                end

                default: counter <= 3'd0;
            endcase
        end
    end

endmodule