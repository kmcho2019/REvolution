module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // State counter
    reg [2:0] counter;

    // Inputs fields
    reg a_sign, b_sign, z_sign;
    reg [9:0] a_exp, b_exp, z_exp; // extended exponent width for calculations
    reg [23:0] a_man, b_man, z_man; // mantissas including implicit 1

    // Mantissa product and rounding bits
    reg [47:0] product; // 24x24=48 bits product
    reg guard, round, sticky;

    // Special flags
    reg a_zero, b_zero, a_inf, b_inf, a_nan, b_nan;

    // IEEE-754 parameters
    localparam EXP_BIAS = 127;
    localparam EXP_MAX  = 8'hFF;
    localparam EXP_ZERO = 8'h00;

    // Extract fields from inputs
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

    // Temporary variables for rounding step
    reg [23:0] mantissa_rounded;
    reg [9:0] exponent_rounded;
    reg mantissa_overflow;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;

            a_sign <= 0; b_sign <= 0; z_sign <= 0;
            a_exp <= 0; b_exp <= 0; z_exp <= 0;
            a_man <= 0; b_man <= 0; z_man <= 0;

            product <= 0;
            guard <= 0; round <= 0; sticky <= 0;

            a_zero <= 0; b_zero <= 0; a_inf <= 0; b_inf <= 0; a_nan <= 0; b_nan <= 0;

            mantissa_rounded <= 0;
            exponent_rounded <= 0;
            mantissa_overflow <= 0;

        end else begin
            case (counter)
                3'd0: begin
                    // Extract sign, exponent, mantissa including implicit 1 or zero for denormals/zero
                    a_sign <= a_s;
                    b_sign <= b_s;
                    z_sign <= a_s ^ b_s;

                    a_exp <= {2'b00, a_exp_in}; // zero extend to 10 bits
                    b_exp <= {2'b00, b_exp_in};

                    a_zero <= (a_exp_zero && a_frac_zero);
                    b_zero <= (b_exp_zero && b_frac_zero);
                    a_inf  <= (a_exp_all_ones && a_frac_zero);
                    b_inf  <= (b_exp_all_ones && b_frac_zero);
                    a_nan  <= (a_exp_all_ones && !a_frac_zero);
                    b_nan  <= (b_exp_all_ones && !b_frac_zero);

                    // Mantissa prep: normalized has implicit 1, denormals zero leading
                    a_man <= (a_exp_zero) ? {1'b0, a_frac} : {1'b1, a_frac};
                    b_man <= (b_exp_zero) ? {1'b0, b_frac} : {1'b1, b_frac};

                    // Reset outputs and intermediate signals
                    z <= 32'd0;
                    product <= 48'd0;
                    guard <= 0; round <= 0; sticky <= 0;
                    z_exp <= 0;
                    z_man <= 0;

                    counter <= 3'd1;
                end

                3'd1: begin
                    // Handle special cases early

                    // NaN -> propagate NaN
                    if (a_nan || b_nan) begin
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN
                        counter <= 3'd0;

                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * zero = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN
                        counter <= 3'd0;

                    end else if (a_inf || b_inf) begin
                        // Inf * nonzero = Inf with sign
                        z <= {z_sign, 8'hFF, 23'd0};
                        counter <= 3'd0;

                    end else if (a_zero || b_zero) begin
                        // zero * anything = zero with sign
                        z <= {z_sign, 31'd0};
                        counter <= 3'd0;

                    end else begin
                        // Normal multiply path

                        // Exponent sum minus bias
                        z_exp <= a_exp + b_exp - EXP_BIAS;

                        // Mantissa multiply
                        product <= a_man * b_man; // 24x24 multiplication

                        counter <= 3'd2;
                    end
                end

                3'd2: begin
                    // Normalize product mantissa and extract rounding bits
                    // product is 48 bits: product[47] is MSB

                    if (product[47]) begin
                        // Leading 1 at bit 47 => normalized, exponent increment by 1
                        z_man <= product[46:23]; // take bits [46:23] as mantissa
                        z_exp <= z_exp + 1;

                        // Rounding bits
                        guard <= product[22];
                        round <= product[21];
                        sticky <= |product[20:0];

                    end else begin
                        // Leading 1 at bit 46 => normalize by shifting left 1, exponent unchanged
                        z_man <= product[45:22]; // bits [45:22]
                        // exponent unchanged

                        guard <= product[21];
                        round <= product[20];
                        sticky <= |product[19:0];
                    end

                    counter <= 3'd3;
                end

                3'd3: begin
                    // Rounding to nearest even
                    mantissa_rounded = z_man;
                    exponent_rounded = z_exp;
                    mantissa_overflow = 0;

                    // Round up if guard==1 and (round or sticky or lsb == 1)
                    if (guard && (round || sticky || mantissa_rounded[0])) begin
                        mantissa_rounded = mantissa_rounded + 1'b1;

                        if (mantissa_rounded == 24'h1000000) begin
                            // mantissa overflow: shift right by 1, increment exponent
                            mantissa_rounded = 24'h800000;
                            exponent_rounded = exponent_rounded + 1;
                            mantissa_overflow = 1;
                        end
                    end

                    // Save rounded values for next cycle
                    z_man <= mantissa_rounded;
                    z_exp <= exponent_rounded;

                    counter <= 3'd4;
                end

                3'd4: begin
                    // Handle overflow, underflow and assemble output

                    // If exponent overflows 8 bits max => infinity
                    if (z_exp[9:8] != 2'b00 || z_exp[7:0] >= EXP_MAX) begin
                        z <= {z_sign, 8'hFF, 23'd0}; // infinity

                    end else if (z_exp[7:0] <= 0) begin
                        // Underflow to zero (flush)
                        z <= {z_sign, 31'd0};

                    end else begin
                        // Normal number output
                        // Remove implicit leading 1 from mantissa (bit 23)
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