module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    localparam EXP_BIAS = 127;

    reg [2:0] counter;

    // Extracted fields
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Extended mantissas with implicit leading 1 for normalized numbers
    reg [23:0] a_mantissa, b_mantissa;

    // Special flags
    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // Intermediate signals for product
    reg [47:0] product;       // 24x24 multiplication
    reg [9:0] exp_sum;        // sum of exponents minus bias (to allow overflow)
    reg sign_result;

    // Normalized mantissa and exponent before rounding
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounding result
    reg [24:0] mantissa_rounded;
    reg [9:0] exponent_rounded;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            // Clear all intermediate registers
            a_sign <= 1'b0; b_sign <= 1'b0;
            a_exp <= 8'd0; b_exp <= 8'd0;
            a_frac <= 23'd0; b_frac <= 23'd0;
            a_mantissa <= 24'd0; b_mantissa <= 24'd0;
            a_zero <= 1'b0; b_zero <= 1'b0;
            a_inf <= 1'b0; b_inf <= 1'b0;
            a_nan <= 1'b0; b_nan <= 1'b0;
            product <= 48'd0;
            exp_sum <= 10'd0;
            sign_result <= 1'b0;
            norm_mantissa <= 24'd0;
            norm_exponent <= 10'd0;
            guard_bit <= 1'b0; round_bit <= 1'b0; sticky_bit <= 1'b0;
            mantissa_rounded <= 25'd0;
            exponent_rounded <= 10'd0;
        end else begin
            case(counter)
                3'd0: begin
                    // Extract sign, exponent, fraction and set special flags
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Determine special cases
                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                    a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                    a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Prepare mantissas with implicit leading 1 for normals, 0 for denormals
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Compute sign of result
                    sign_result <= a[31] ^ b[31];

                    counter <= 3'd1;
                end
                3'd1: begin
                    // Multiply mantissas and add exponents adjusting bias
                    product <= a_mantissa * b_mantissa;  // 24x24=48 bits
                    exp_sum <= a_exp + b_exp - EXP_BIAS; // 10-bit wide to hold overflow

                    counter <= 3'd2;
                end
                3'd2: begin
                    // Normalize product
                    if (product[47]) begin
                        // MSB is 1, product >=2.0, shift right and increment exponent
                        norm_mantissa <= product[47:24]; // top 24 bits
                        norm_exponent <= exp_sum + 10'd1;

                        // Rounding bits
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        // MSB is 0, product < 2.0, no shift, exponent unchanged
                        norm_mantissa <= product[46:23];
                        norm_exponent <= exp_sum;

                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end

                    counter <= 3'd3;
                end
                3'd3: begin
                    // Rounding and handle special cases

                    // Handle special cases first
                    if (a_nan || b_nan) begin
                        // Output quiet NaN: sign=0, exponent=all 1s, mantissa MSB=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf*0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Infinity result
                        z <= {sign_result, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // Zero result
                        z <= {sign_result, 31'd0};
                    end else begin
                        // Normal rounding to nearest even

                        // Round increment if guard=1 and (round or sticky or LSB)
                        if (guard_bit && (round_bit | sticky_bit | norm_mantissa[0]))
                            mantissa_rounded <= {1'b0, norm_mantissa} + 25'd1;
                        else
                            mantissa_rounded <= {1'b0, norm_mantissa};

                        // Handle mantissa overflow after rounding
                        if (mantissa_rounded[24]) begin
                            exponent_rounded <= norm_exponent + 10'd1;
                            // Shift mantissa right by 1 after overflow: drop lowest bit
                            // Take bits [24:2] to get 23 bits fraction + leading 1 implicit
                            z <= {sign_result,
                                  (exponent_rounded[7:0] >= 8'hFF) ? 8'hFF : exponent_rounded[7:0],
                                  (exponent_rounded[7:0] >= 8'hFF) ? 23'd0 : mantissa_rounded[23:1]};
                        end else begin
                            exponent_rounded <= norm_exponent;
                            // Normal case: bits [23:1] is fraction (implicit leading 1)
                            if (exponent_rounded >= 10'd255) begin
                                // Overflow: infinity
                                z <= {sign_result, 8'hFF, 23'd0};
                            end else if (exponent_rounded <= 0) begin
                                // Underflow to zero (flush)
                                z <= {sign_result, 31'd0};
                            end else begin
                                z <= {sign_result, exponent_rounded[7:0], mantissa_rounded[22:0]};
                            end
                        end
                    end

                    counter <= 3'd0; // Ready for next input
                end
            endcase
        end
    end

endmodule