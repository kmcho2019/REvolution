module float_multi (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Parameters for IEEE-754 single precision
    localparam EXP_BIAS = 127;
    localparam EXP_MAX  = 8'hFF;
    localparam EXP_ZERO = 8'h00;

    // State counter for sequencing pipeline steps
    reg [2:0] counter;

    // Input field registers
    reg         a_sign, b_sign, z_sign;
    reg [9:0]   a_exp, b_exp, z_exp;          // extended exponent for internal calc (10 bits)
    reg [23:0]  a_man, b_man, z_man;           // mantissa with implicit bit (24 bits)

    // Mantissa product and rounding bits
    reg [47:0]  product;                        // 24x24=48 bits
    reg         guard, round_bit, sticky;      // rounding bits

    // Special cases
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;

    // Intermediate variables for rounding step
    reg [24:0] mantissa_rounded_25;            // 25 bits to detect overflow after rounding
    reg [9:0]  exponent_rounded;

    // Extract fields from inputs (combinational)
    wire [7:0] a_exp_in = a[30:23];
    wire [7:0] b_exp_in = b[30:23];
    wire [22:0] a_frac = a[22:0];
    wire [22:0] b_frac = b[22:0];
    wire a_s = a[31];
    wire b_s = b[31];

    // Detect special cases on inputs
    wire a_exp_all_ones = (a_exp_in == EXP_MAX);
    wire b_exp_all_ones = (b_exp_in == EXP_MAX);
    wire a_exp_zero = (a_exp_in == EXP_ZERO);
    wire b_exp_zero = (b_exp_in == EXP_ZERO);
    wire a_frac_zero = (a_frac == 0);
    wire b_frac_zero = (b_frac == 0);

    // Helper wires for sticky calculation
    wire sticky_from_lower_bits;

    always @(posedge clk) begin
        if (rst) begin
            // Reset all outputs and internal states
            counter <= 3'd0;
            z <= 32'd0;

            a_sign <= 1'b0;
            b_sign <= 1'b0;
            z_sign <= 1'b0;

            a_exp <= 10'd0;
            b_exp <= 10'd0;
            z_exp <= 10'd0;

            a_man <= 24'd0;
            b_man <= 24'd0;
            z_man <= 24'd0;

            product <= 48'd0;

            guard <= 1'b0;
            round_bit <= 1'b0;
            sticky <= 1'b0;

            a_zero <= 1'b0;
            b_zero <= 1'b0;
            a_inf <= 1'b0;
            b_inf <= 1'b0;
            a_nan <= 1'b0;
            b_nan <= 1'b0;

            mantissa_rounded_25 <= 25'd0;
            exponent_rounded <= 10'd0;

        end else begin
            case (counter)
                3'd0: begin
                    // Extract sign, exponent, mantissa (with implicit 1 for normalized)
                    a_sign <= a_s;
                    b_sign <= b_s;
                    z_sign <= a_s ^ b_s;

                    // Extend exponent to 10 bits for intermediate calc
                    a_exp <= {2'b00, a_exp_in};
                    b_exp <= {2'b00, b_exp_in};

                    // Detect special cases
                    a_zero <= (a_exp_zero && a_frac_zero);
                    b_zero <= (b_exp_zero && b_frac_zero);
                    a_inf  <= (a_exp_all_ones && a_frac_zero);
                    b_inf  <= (b_exp_all_ones && b_frac_zero);
                    a_nan  <= (a_exp_all_ones && !a_frac_zero);
                    b_nan  <= (b_exp_all_ones && !b_frac_zero);

                    // Prepare mantissas: normalized -> implicit leading 1, denormal -> leading 0
                    a_man <= a_exp_zero ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_man <= b_exp_zero ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Clear output and intermediates
                    z <= 32'd0;
                    product <= 48'd0;
                    guard <= 1'b0;
                    round_bit <= 1'b0;
                    sticky <= 1'b0;
                    z_exp <= 10'd0;
                    z_man <= 24'd0;
                    mantissa_rounded_25 <= 25'd0;
                    exponent_rounded <= 10'd0;

                    counter <= 3'd1;
                end

                3'd1: begin
                    // Special cases handling
                    if (a_nan || b_nan) begin
                        // If either input is NaN, output quiet NaN
                        // quiet NaN pattern: sign=0, exp=0xFF, MSB mantissa=1, rest=0
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        counter <= 3'd0;
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * zero = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        counter <= 3'd0;
                    end else if (a_inf || b_inf) begin
                        // Inf * nonzero = Inf
                        z <= {z_sign, 8'hFF, 23'd0};
                        counter <= 3'd0;
                    end else if (a_zero || b_zero) begin
                        // zero * anything = zero
                        z <= {z_sign, 31'd0};
                        counter <= 3'd0;
                    end else begin
                        // Normal multiplication path
                        // Calculate exponent sum minus bias (store as 10-bit extended)
                        z_exp <= a_exp + b_exp - EXP_BIAS;

                        // Multiply mantissas (24x24 -> 48 bits)
                        product <= a_man * b_man;

                        counter <= 3'd2;
                    end
                end

                3'd2: begin
                    // Normalize product mantissa and extract rounding bits
                    // product[47] is MSB of product

                    if (product[47]) begin
                        // Leading one at bit 47: normalized result, exponent incremented
                        z_man <= product[46:23];         // take bits [46:23] as mantissa (24 bits)
                        z_exp <= z_exp + 1;

                        guard <= product[22];
                        round_bit <= product[21];
                        sticky <= |product[20:0];
                    end else begin
                        // Leading one at bit 46: shift left by 1, exponent unchanged
                        z_man <= product[45:22];         // bits [45:22] as mantissa
                        // exponent unchanged

                        guard <= product[21];
                        round_bit <= product[20];
                        sticky <= |product[19:0];
                    end

                    counter <= 3'd3;
                end

                3'd3: begin
                    // Rounding to nearest even
                    mantissa_rounded_25 = {1'b0, z_man}; // extend to 25 bits for overflow detection
                    exponent_rounded = z_exp;

                    if (guard && (round_bit || sticky || mantissa_rounded_25[0])) begin
                        mantissa_rounded_25 = mantissa_rounded_25 + 1'b1;
                        if (mantissa_rounded_25[24]) begin
                            // Mantissa overflow (25th bit set), shift right by 1 and increase exponent
                            mantissa_rounded_25 = mantissa_rounded_25 >> 1;
                            exponent_rounded = exponent_rounded + 1;
                        end
                    end

                    // Save rounded mantissa and exponent for final output
                    z_man <= mantissa_rounded_25[23:0];
                    z_exp <= exponent_rounded;

                    counter <= 3'd4;
                end

                3'd4: begin
                    // Handle exponent overflow, underflow, and assemble output

                    // Overflow: exponent exceeds max (255)
                    // Check upper bits of exponent (z_exp is 10 bits)
                    // exponent_rounded could be larger than 255, so overflow if >255
                    if (z_exp > EXP_MAX) begin
                        // Infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (z_exp <= 0) begin
                        // Underflow - flush to zero (no gradual underflow handling here)
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal number
                        // Output is sign + exponent + mantissa (remove implicit leading 1 bit)
                        z <= {z_sign, z_exp[7:0], z_man[22:0]};
                    end

                    counter <= 3'd0;
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule