module float_multi(
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Constants
    localparam EXP_BIAS = 127;

    // State counter: 3-bit to index operation steps
    reg [2:0] counter;

    // Internal registers for operands extraction and intermediate storage
    reg         a_sign, b_sign;
    reg  [7:0]  a_exponent, b_exponent;
    reg  [22:0] a_fraction, b_fraction;
    reg  [23:0] a_mantissa, b_mantissa;
    reg  [9:0]  z_exponent;     // wider to handle exponent arithmetic
    reg  [23:0] z_mantissa;
    reg         z_sign;

    // Intermediate multiplication product (24x24 = 48 bits)
    reg  [47:0] product;

    // Special case flags
    reg a_zero, b_zero;
    reg a_inf,  b_inf;
    reg a_nan,  b_nan;

    // Normalization signals
    reg normalize_shift; // 1 if need to shift mantissa right by 1

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Signals for rounding logic
    reg [24:0] mantissa_with_round; // 24 mantissa + 1 carry bit
    reg [9:0]  exponent_rounded;

    // Temporary signals (combinational)
    wire a_is_denorm;
    wire b_is_denorm;

    // Sticky bit calculation (combinational)
    wire sticky_comb;

    // Extract inputs - combinational to assign to registers at first cycle
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;

            // Reset outputs and intermediate regs
            a_sign <= 0; b_sign <= 0;
            a_exponent <= 0; b_exponent <= 0;
            a_fraction <= 0; b_fraction <= 0;
            a_mantissa <= 0; b_mantissa <= 0;
            a_zero <= 0; b_zero <= 0;
            a_inf <= 0; b_inf <= 0;
            a_nan <= 0; b_nan <= 0;
            z_sign <= 0;
            z_exponent <= 0;
            z_mantissa <= 0;
            product <= 0;
            normalize_shift <= 0;
            guard_bit <= 0;
            round_bit <= 0;
            sticky_bit <= 0;
            mantissa_with_round <= 0;
            exponent_rounded <= 0;
            z <= 32'd0;
        end else begin
            case (counter)
                3'd0: begin
                    // Extract sign, exponent, fraction, special flags
                    a_sign <= a[31];
                    b_sign <= b[31];

                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];

                    a_fraction <= a[22:0];
                    b_fraction <= b[22:0];

                    // Detect zeros
                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                    // Detect infinity
                    a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                    b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                    // Detect NaN
                    a_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                    b_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                    // Prepare mantissas with implicit leading 1 for normalized, 0 for denormals
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    counter <= 3'd1;
                end

                3'd1: begin
                    // Multiply mantissas and sum exponents

                    // Product is 48 bits: 24 x 24 multiplication
                    product <= a_mantissa * b_mantissa;

                    // Exponent addition with bias subtraction
                    // Cast to 10 bits to hold sum - bias safely
                    z_exponent <= ( {2'b00,a_exponent} + {2'b00,b_exponent} ) - EXP_BIAS;

                    // Sign is XOR
                    z_sign <= a_sign ^ b_sign;

                    counter <= 3'd2;
                end

                3'd2: begin
                    // Normalize the product and determine rounding bits

                    // Check MSB of product for normalization
                    if (product[47]) begin
                        normalize_shift <= 1'b1;
                        z_exponent <= z_exponent + 1;
                        z_mantissa <= product[47:24]; // top 24 bits
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky_bit <= |product[21:0];
                    end else begin
                        normalize_shift <= 1'b0;
                        z_mantissa <= product[46:23]; // shifted one less bit
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky_bit <= |product[20:0];
                    end

                    counter <= 3'd3;
                end

                3'd3: begin
                    // Rounding and final output assembly

                    // Handle special cases first (NaN, Inf, zero)
                    if (a_nan || b_nan) begin
                        // Quiet NaN: sign=0, exp=0xFF, MSB of mantissa=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Infinity times non-zero = infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // Zero times anything = zero
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Round to nearest even

                        // Round increment condition: guard & (round | sticky | LSB)
                        mantissa_with_round = {1'b0, z_mantissa} + (guard_bit & (round_bit | sticky_bit | z_mantissa[0]) ? 25'd1 : 25'd0);

                        // Handle mantissa overflow after rounding
                        if (mantissa_with_round[24]) begin
                            exponent_rounded = z_exponent + 1;
                            // Shift mantissa right by 1 (drop LSB)
                            z_mantissa <= mantissa_with_round[24:2];
                        end else begin
                            exponent_rounded = z_exponent;
                            z_mantissa <= mantissa_with_round[23:1];
                        end

                        // Check for overflow and underflow on exponent
                        if (exponent_rounded >= 255) begin
                            // Overflow to Infinity
                            z <= {z_sign, 8'hFF, 23'd0};
                        end else if (exponent_rounded <= 0) begin
                            // Underflow to zero (flush)
                            z <= {z_sign, 31'd0};
                        end else begin
                            // Normal number
                            z <= {z_sign, exponent_rounded[7:0], z_mantissa[22:0]};
                        end
                    end

                    // Restart counter
                    counter <= 3'd0;
                end

                default: counter <= 3'd0;
            endcase
        end
    end

endmodule