module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);
    // States
    localparam IDLE = 3'd0;
    localparam CHECK = 3'd1;
    localparam MULTIPLY = 3'd2;
    localparam NORMALIZE_ROUND = 3'd3;
    localparam OUTPUT = 3'd4;

    reg [2:0] counter;  // state counter

    // Extracted input fields
    reg a_sign, b_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [22:0] a_fraction, b_fraction;

    // Extended mantissas (24 bits with implicit leading 1 for normalized)
    reg [23:0] a_mantissa, b_mantissa;
    reg [23:0] z_mantissa;

    // Exponent calculation (10 bits for intermediate)
    reg [9:0] a_exp_ext, b_exp_ext, z_exponent;

    // Signs
    reg a_sgn, b_sgn, z_sign;

    // 48-bit product (24x24 multiplier)
    reg [47:0] product;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Flags for special cases
    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // Intermediate normalized mantissa and exponent
    reg [23:0] normalized_mantissa;
    reg [9:0] normalized_exponent;

    // Rounding increment flag
    reg round_increment;

    // Constants
    localparam EXP_BIAS = 127;

    // Predefined outputs for special cases
    localparam [31:0] QUIET_NAN = {1'b0, 8'hFF, 1'b1, 22'd0};
    localparam [31:0] POS_INF = {1'b0, 8'hFF, 23'd0};
    localparam [31:0] NEG_INF = {1'b1, 8'hFF, 23'd0};
    localparam [31:0] ZERO_POS = 32'd0;

    // FSM sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= IDLE;
            z <= 32'd0;

            a_sign <= 0;
            b_sign <= 0;
            a_exponent <= 0;
            b_exponent <= 0;
            a_fraction <= 0;
            b_fraction <= 0;
            a_mantissa <= 0;
            b_mantissa <= 0;
            a_exp_ext <= 0;
            b_exp_ext <= 0;

            a_zero <= 0;
            b_zero <= 0;
            a_inf <= 0;
            b_inf <= 0;
            a_nan <= 0;
            b_nan <= 0;

            z_sign <= 0;
            z_exponent <= 0;
            product <= 0;
            guard_bit <= 0;
            round_bit <= 0;
            sticky_bit <= 0;

            normalized_mantissa <= 0;
            normalized_exponent <= 0;
            round_increment <= 0;
        end else begin
            case (counter)
                IDLE: begin
                    // Extract inputs fields
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_fraction <= a[22:0];
                    b_fraction <= b[22:0];

                    // Special case flags
                    a_zero <= (a[30:0] == 31'd0);
                    b_zero <= (b[30:0] == 31'd0);

                    a_inf <= (a_exponent == 8'hFF) && (a_fraction == 23'd0);
                    b_inf <= (b_exponent == 8'hFF) && (b_fraction == 23'd0);

                    a_nan <= (a_exponent == 8'hFF) && (a_fraction != 23'd0);
                    b_nan <= (b_exponent == 8'hFF) && (b_fraction != 23'd0);

                    counter <= CHECK;
                end

                CHECK: begin
                    z_sign <= a_sign ^ b_sign;

                    // Handle special cases immediately and move to OUTPUT
                    if (a_nan || b_nan) begin
                        z <= QUIET_NAN;
                        counter <= OUTPUT;
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        z <= QUIET_NAN;
                        counter <= OUTPUT;
                    end else if (a_inf || b_inf) begin
                        // Infinity * finite or Inf*Inf
                        z <= z_sign ? NEG_INF : POS_INF;
                        counter <= OUTPUT;
                    end else if (a_zero || b_zero) begin
                        // zero * anything = zero (signed zero)
                        z <= {z_sign, 31'd0};
                        counter <= OUTPUT;
                    end else begin
                        // Normal operands, prepare mantissas and exponents
                        // For normalized numbers, implicit 1; for denormals, leading 0
                        a_mantissa <= (a_exponent == 8'd0) ? {1'b0, a_fraction} : {1'b1, a_fraction};
                        b_mantissa <= (b_exponent == 8'd0) ? {1'b0, b_fraction} : {1'b1, b_fraction};
                        a_exp_ext <= (a_exponent == 8'd0) ? 10'd1 : {2'd0, a_exponent}; // For denormals, exponent = 1 (to simplify)
                        b_exp_ext <= (b_exponent == 8'd0) ? 10'd1 : {2'd0, b_exponent};

                        counter <= MULTIPLY;
                    end
                end

                MULTIPLY: begin
                    // Multiply mantissas (24x24 = 48 bits)
                    product <= a_mantissa * b_mantissa;
                    // Add exponents and subtract bias; bias 127 is 10-bit, safe for addition
                    z_exponent <= a_exp_ext + b_exp_ext - EXP_BIAS;
                    counter <= NORMALIZE_ROUND;
                end

                NORMALIZE_ROUND: begin
                    // Normalize product and exponent:
                    // If MSB (bit 47) is 1, product is already normalized
                    if (product[47]) begin
                        normalized_mantissa <= product[47:24];
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                        normalized_exponent <= z_exponent + 1;
                    end else begin
                        // Otherwise shift left 1 (normalize)
                        normalized_mantissa <= product[46:23];
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                        normalized_exponent <= z_exponent;
                    end

                    // Determine round increment (round to nearest even)
                    // Round if guard bit set and (round bit or sticky bit or LSB=1)
                    round_increment <= guard_bit & (round_bit | sticky_bit | normalized_mantissa[0]);

                    counter <= OUTPUT;
                end

                OUTPUT: begin
                    reg [24:0] mantissa_rounded; // 25-bit for potential carry

                    // Apply rounding increment
                    mantissa_rounded = {1'b0, normalized_mantissa} + round_increment;

                    // Adjust exponent if mantissa overflow after rounding
                    if (mantissa_rounded[24]) begin
                        normalized_exponent = normalized_exponent + 1;
                        normalized_mantissa = mantissa_rounded[24:1];
                    end else begin
                        normalized_mantissa = mantissa_rounded[23:0];
                    end

                    // Handle overflow and underflow
                    if (normalized_exponent >= 10'd255) begin
                        // Overflow to infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (normalized_exponent <= 0) begin
                        // Underflow to zero (flush)
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normalized result
                        z <= {z_sign, normalized_exponent[7:0], normalized_mantissa[22:0]};
                    end

                    counter <= IDLE; // Ready for next input
                end

                default: counter <= IDLE;
            endcase
        end
    end

endmodule