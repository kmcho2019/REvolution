module float_multi (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);
    localparam EXP_BIAS = 127;

    // Internal registers and wires
    reg [2:0] counter;

    reg a_sign, b_sign, z_sign;
    reg [9:0] a_exponent, b_exponent, z_exponent;   // Extended 10-bit exponent to avoid overflow
    reg [23:0] a_mantissa, b_mantissa, z_mantissa; // 24-bit mantissas including implicit bit

    reg [49:0] product; // 24x24 multiply result (up to 48 bits), stored as 50 bits for rounding bits

    reg guard_bit, round_bit, sticky_bit;

    // Special case flags
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;
    reg any_nan, any_inf, any_zero, inf_zero;

    // Internal normalized mantissa and exponent registers after multiply
    reg product_msb;
    reg [23:0] mantissa_norm;
    reg [9:0] exponent_norm;

    // Rounded mantissa with possible overflow bit
    reg [24:0] mantissa_rounded;

    // Rounding increment bit
    reg round_increment;

    // Intermediate signals for sticky bit calculation
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];

    wire [7:0] a_exp_in = a[30:23];
    wire [7:0] b_exp_in = b[30:23];

    wire a_sign_in = a[31];
    wire b_sign_in = b[31];

    // State machine - counter increments 0 to 4 for operation sequencing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
        end else if (counter == 3'd4) begin
            counter <= 3'd0; // cycle complete, ready for next inputs
        end else begin
            counter <= counter + 3'd1;
        end
    end

    // Main sequential logic for each cycle
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            a_exponent <= 10'd0;
            b_exponent <= 10'd0;
            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;

            product <= 50'd0;

            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky_bit <= 1'b0;

            a_zero <= 1'b0;
            b_zero <= 1'b0;
            a_inf <= 1'b0;
            b_inf <= 1'b0;
            a_nan <= 1'b0;
            b_nan <= 1'b0;

            any_nan <= 1'b0;
            any_inf <= 1'b0;
            any_zero <= 1'b0;
            inf_zero <= 1'b0;

            product_msb <= 1'b0;
            mantissa_norm <= 24'd0;
            exponent_norm <= 10'd0;

            mantissa_rounded <= 25'd0;
            round_increment <= 1'b0;

            z_sign <= 1'b0;
            z_exponent <= 10'd0;
            z_mantissa <= 24'd0;

            z <= 32'd0;
        end else begin
            case (counter)
                3'd0: begin
                    // Cycle 0: Sample inputs, extract sign, exponent, mantissa, detect special cases
                    a_sign <= a_sign_in;
                    b_sign <= b_sign_in;
                    z_sign <= a_sign_in ^ b_sign_in;

                    // Detect zeros
                    a_zero <= (a_exp_in == 8'd0) && (a_frac == 23'd0);
                    b_zero <= (b_exp_in == 8'd0) && (b_frac == 23'd0);

                    // Detect infinity
                    a_inf <= (a_exp_in == 8'hFF) && (a_frac == 23'd0);
                    b_inf <= (b_exp_in == 8'hFF) && (b_frac == 23'd0);

                    // Detect NaN
                    a_nan <= (a_exp_in == 8'hFF) && (a_frac != 23'd0);
                    b_nan <= (b_exp_in == 8'hFF) && (b_frac != 23'd0);

                    any_nan <= ((a_exp_in == 8'hFF) && (a_frac != 23'd0)) || ((b_exp_in == 8'hFF) && (b_frac != 23'd0));
                    any_inf <= (a_exp_in == 8'hFF && a_frac == 0) || (b_exp_in == 8'hFF && b_frac == 0);
                    any_zero <= ((a_exp_in == 8'd0) && (a_frac == 0)) || ((b_exp_in == 8'd0) && (b_frac == 0));
                    inf_zero <= ((a_exp_in == 8'hFF) && (a_frac == 0) && (b_exp_in == 8'd0) && (b_frac == 0)) ||
                                ((b_exp_in == 8'hFF) && (b_frac == 0) && (a_exp_in == 8'd0) && (a_frac == 0));

                    // Exponents extended to 10-bit: 0 exponent denormals treated as 1 per IEEE 754 rules for calculation
                    a_exponent <= (a_exp_in == 8'd0) ? 10'd1 : {2'b00, a_exp_in};
                    b_exponent <= (b_exp_in == 8'd0) ? 10'd1 : {2'b00, b_exp_in};

                    // Mantissa with implicit leading 1 for normalized, 0 for denormals
                    a_mantissa <= (a_exp_in == 8'd0) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_mantissa <= (b_exp_in == 8'd0) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Clear product and rounding bits for next stages
                    product <= 50'd0;
                    guard_bit <= 1'b0;
                    round_bit <= 1'b0;
                    sticky_bit <= 1'b0;

                    // Clear normalized mantissa and exponent for next stages
                    mantissa_norm <= 24'd0;
                    exponent_norm <= 10'd0;

                    mantissa_rounded <= 25'd0;
                    round_increment <= 1'b0;

                    // Clear output registers except sign
                    z_exponent <= 10'd0;
                    z_mantissa <= 24'd0;
                end

                3'd1: begin
                    // Cycle 1: Perform 24x24 mantissa multiplication (a_mantissa * b_mantissa)
                    // Multiplication produces 48-bit product stored in 50-bit reg for rounding safety
                    product <= a_mantissa * b_mantissa;
                end

                3'd2: begin
                    // Cycle 2: Normalize product and calculate new exponent
                    // Calculate exponent sum minus bias (bias=127)
                    // Use extended exponent width (10 bits) to prevent overflow
                    // product is 48 bits from 24x24 multiplication
                    // Check MSB for normalization:
                    // If MSB=1 at product[47], shift mantissa right zero bits (already normalized), else shift left 1 (multiply by 2)
                    reg [9:0] exp_sum;
                    exp_sum = a_exponent + b_exponent - EXP_BIAS;

                    product_msb <= product[47];

                    if (product[47]) begin
                        mantissa_norm <= product[47:24];  // Take top 24 bits as mantissa
                        exponent_norm <= exp_sum + 10'd1; // Adjust exponent (+1) because MSB is set
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        mantissa_norm <= product[46:23];
                        exponent_norm <= exp_sum;
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end
                end

                3'd3: begin
                    // Cycle 3: Rounding - round to nearest even
                    round_increment <= guard_bit && (round_bit || sticky_bit || mantissa_norm[0]);

                    mantissa_rounded <= {1'b0, mantissa_norm} + round_increment;
                end

                3'd4: begin
                    // Cycle 4: Finalize mantissa, exponent, handle overflow/underflow, special cases, and prepare output

                    // Check if rounding caused mantissa overflow (bit 24)
                    if (mantissa_rounded[24]) begin
                        z_exponent <= exponent_norm + 10'd1;
                        z_mantissa <= mantissa_rounded[24:2]; // Shift right by one to keep 23 bits
                    end else begin
                        z_exponent <= exponent_norm;
                        z_mantissa <= mantissa_rounded[22:0];
                    end

                    // Handle special cases
                    if (any_nan) begin
                        // Quiet NaN (Exponents all 1s, MSB of mantissa set)
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (inf_zero) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (any_inf) begin
                        // Inf * non-zero = Inf
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (any_zero) begin
                        // Zero * anything = zero
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal number handling overflow and underflow

                        if (z_exponent >= 10'd255) begin
                            // Overflow: set to infinity
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (z_exponent <= 10'd0) begin
                            // Underflow flush to zero (subnormals not handled for simplicity)
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Normal packing of exponent and mantissa
                            z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                        end
                    end

                    // No further changes until next input sample
                end

                default: begin
                    // Should not occur
                end
            endcase
        end
    end

endmodule