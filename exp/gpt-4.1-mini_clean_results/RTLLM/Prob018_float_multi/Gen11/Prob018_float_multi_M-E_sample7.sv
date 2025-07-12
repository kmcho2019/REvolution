module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Internal registers as requested
    reg [2:0] counter;

    reg a_sign, b_sign, z_sign;
    reg [9:0] a_exponent, b_exponent, z_exponent; // 10 bits for intermediate calculations
    reg [23:0] a_mantissa, b_mantissa, z_mantissa; // 24 bits including hidden leading 1

    reg [49:0] product; // 24x24 multiplication => 48 bits needed, use 50 bits for shifts

    // Rounding bits
    reg guard_bit, round_bit, sticky;

    // Internal flags for special cases
    reg a_is_zero, b_is_zero;
    reg a_is_inf, b_is_inf;
    reg a_is_nan, b_is_nan;
    reg is_nan_result, is_inf_result, is_zero_result;

    localparam EXP_BIAS = 127;

    // Extract raw fields from inputs - combinationally used in cycle 0
    wire [7:0] a_exp_raw = a[30:23];
    wire [7:0] b_exp_raw = b[30:23];
    wire [22:0] a_frac_raw = a[22:0];
    wire [22:0] b_frac_raw = b[22:0];
    wire a_sign_raw = a[31];
    wire b_sign_raw = b[31];

    // Sticky bit calculation helper function (used combinationally)
    function sticky_bit_calc;
        input [20:0] bits;
        integer i;
        begin
            sticky_bit_calc = 1'b0;
            for (i = 0; i < 21; i=i+1) begin
                if (bits[i]) sticky_bit_calc = 1'b1;
            end
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all internal registers
            counter <= 3'd0;
            z <= 32'd0;

            a_sign <= 1'b0;
            b_sign <= 1'b0;
            z_sign <= 1'b0;

            a_exponent <= 10'd0;
            b_exponent <= 10'd0;
            z_exponent <= 10'd0;

            a_mantissa <= 24'd0;
            b_mantissa <= 24'd0;
            z_mantissa <= 24'd0;

            product <= 50'd0;

            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky <= 1'b0;

            a_is_zero <= 1'b0;
            b_is_zero <= 1'b0;
            a_is_inf <= 1'b0;
            b_is_inf <= 1'b0;
            a_is_nan <= 1'b0;
            b_is_nan <= 1'b0;

            is_nan_result <= 1'b0;
            is_inf_result <= 1'b0;
            is_zero_result <= 1'b0;

        end else begin
            case (counter)
                3'd0: begin
                    // Extract sign, exponent, mantissa and identify special cases

                    // Register sign bits
                    a_sign <= a_sign_raw;
                    b_sign <= b_sign_raw;
                    z_sign <= a_sign_raw ^ b_sign_raw;

                    // Identify special cases
                    a_is_zero <= (a_exp_raw == 8'd0) && (a_frac_raw == 23'd0);
                    b_is_zero <= (b_exp_raw == 8'd0) && (b_frac_raw == 23'd0);

                    a_is_inf <= (a_exp_raw == 8'hFF) && (a_frac_raw == 23'd0);
                    b_is_inf <= (b_exp_raw == 8'hFF) && (b_frac_raw == 23'd0);

                    a_is_nan <= (a_exp_raw == 8'hFF) && (a_frac_raw != 23'd0);
                    b_is_nan <= (b_exp_raw == 8'hFF) && (b_frac_raw != 23'd0);

                    // Prepare mantissas with implicit leading 1 for normals; zero for zeros and denormals
                    // IEEE-754: for exponent!=0 mantissa = 1.fraction else denormal or zero: leading bit=0
                    a_mantissa <= (a_exp_raw == 8'd0) ? {1'b0, a_frac_raw} : {1'b1, a_frac_raw};
                    b_mantissa <= (b_exp_raw == 8'd0) ? {1'b0, b_frac_raw} : {1'b1, b_frac_raw};

                    // Store exponents as 10-bit to allow overflow (use zero for denormals to simplify later)
                    a_exponent <= (a_exp_raw == 8'd0) ? 10'd0 : {2'b00, a_exp_raw};
                    b_exponent <= (b_exp_raw == 8'd0) ? 10'd0 : {2'b00, b_exp_raw};

                    // Clear output flags at start
                    is_nan_result <= 1'b0;
                    is_inf_result <= 1'b0;
                    is_zero_result <= 1'b0;

                    // Move to next stage
                    counter <= 3'd1;
                end

                3'd1: begin
                    // Perform mantissa multiplication and preliminary exponent calculation

                    // If special cases or zeros/inf/nan, skip multiplication (will be handled later)
                    // For normal/denormal multiply mantissas
                    // product = 24x24 mantissa multiplication = 48 bits, stored in 50-bit reg for later shifts
                    product <= a_mantissa * b_mantissa;

                    // Compute preliminary exponent sum: a_exp + b_exp - bias (127)
                    // For zero exponent inputs (denormals or zero), exponent is zero, so exponent sum is valid
                    // Use 10-bit wide to store exponent sum safely
                    z_exponent <= a_exponent + b_exponent - EXP_BIAS;

                    counter <= 3'd2;
                end

                3'd2: begin
                    // Normalize product

                    // product is 48 bits in product[47:0], left justified in 50-bit reg[49:0]
                    // We work with bits [47:0] of product; product is already 48 bits wide

                    // Check if MSB (bit 47) == 1 (meaning product in [2,4) range)
                    if (product[47] == 1'b1) begin
                        // Shift right by 1, increment exponent
                        product <= product >> 1;
                        z_exponent <= z_exponent + 10'd1;
                    end
                    // else product is normalized with leading 1 at bit 46 (in [1,2) range), no shift needed

                    // Extract normalized mantissa bits: bits [46:23] (24 bits with implicit leading 1)
                    z_mantissa <= product[46:23];

                    // Extract rounding bits:
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky <= (|product[20:0]) ? 1'b1 : 1'b0;

                    counter <= 3'd3;
                end

                3'd3: begin
                    // Rounding according to IEEE 754 round to nearest even

                    // Round if guard bit is 1 and (round bit or sticky bit or lsb of mantissa is 1)
                    if (guard_bit && (round_bit | sticky | z_mantissa[0])) begin
                        z_mantissa <= z_mantissa + 24'd1;

                        // Check if mantissa overflowed (exceeded 24 bits: i.e. bit 24 set)
                        if (z_mantissa == 24'hFFFFFF) begin
                            // Mantissa overflow due to rounding
                            z_mantissa <= z_mantissa >> 1;
                            z_exponent <= z_exponent + 10'd1;
                        end
                    end

                    counter <= 3'd4;
                end

                3'd4: begin
                    // Assemble final output, handle special cases, overflow, underflow

                    // Handle special cases first
                    if (a_is_nan || b_is_nan) begin
                        // Result is NaN: exponent all ones, mantissa non-zero (quiet NaN)
                        is_nan_result <= 1'b1;
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN pattern
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        // Inf * 0 => NaN
                        is_nan_result <= 1'b1;
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // Quiet NaN pattern
                    end else if (a_is_inf || b_is_inf) begin
                        // Inf * normal => Inf
                        is_inf_result <= 1'b1;
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (a_is_zero || b_is_zero) begin
                        // Zero * anything => zero
                        is_zero_result <= 1'b1;
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal case: check exponent overflow/underflow
                        if (z_exponent >= 10'd255) begin
                            // Overflow => Infinity
                            is_inf_result <= 1'b1;
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (z_exponent <= 0) begin
                            // Underflow => Zero (flush to zero)
                            is_zero_result <= 1'b1;
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Normal value: assemble IEEE-754 format
                            // Exponent fits in 8 bits (lowest 8 bits of z_exponent)
                            z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                        end
                    end

                    // Prepare for next multiplication
                    counter <= 3'd0;
                end

                default: begin
                    counter <= 3'd0;
                end

            endcase
        end
    end
endmodule