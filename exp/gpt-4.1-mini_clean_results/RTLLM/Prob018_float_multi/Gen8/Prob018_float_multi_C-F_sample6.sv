module float_multi(
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] a,
    input  wire [31:0] b,
    output reg  [31:0] z
);

    // Constants
    localparam EXP_BIAS = 127;

    // Cycle counter (0 to 3)
    reg [2:0] counter;

    // --- Cycle 0: Input extraction and special cases detection ---
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_mantissa, b_mantissa; // implicit 1 for normalized numbers

    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // --- Cycle 1: Mantissa multiply, exponent add, sign compute ---
    reg [47:0] product;      // 24x24 multiplication result
    reg [9:0] exponent_sum;  // wider to hold intermediate exponent sum and bias adjustment
    reg z_sign;

    // --- Cycle 2: Normalization and rounding bit extraction ---
    reg [47:0] norm_product;
    reg [9:0] norm_exponent;

    reg guard_bit, round_bit, sticky_bit;
    reg [23:0] z_mantissa_stage2;

    // --- Cycle 3: Rounding and final output composition ---
    reg round_increment;
    reg [24:0] mantissa_rounded; // 25 bits to detect rounding overflow

    // Special case flags carried over for output mux
    reg special_nan, special_nan_out, special_inf, special_zero;

    // Temporary signals for sticky calculation
    wire sticky_calc;

    // --- Sequential logic: FSM and pipeline stages ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter          <= 3'd0;
            z                <= 32'd0;

            a_sign           <= 1'b0;
            b_sign           <= 1'b0;
            a_exp            <= 8'd0;
            b_exp            <= 8'd0;
            a_mantissa       <= 24'd0;
            b_mantissa       <= 24'd0;

            a_zero           <= 1'b0;
            b_zero           <= 1'b0;
            a_inf            <= 1'b0;
            b_inf            <= 1'b0;
            a_nan            <= 1'b0;
            b_nan            <= 1'b0;

            product          <= 48'd0;
            exponent_sum     <= 10'd0;
            z_sign           <= 1'b0;

            norm_product     <= 48'd0;
            norm_exponent    <= 10'd0;

            guard_bit        <= 1'b0;
            round_bit        <= 1'b0;
            sticky_bit       <= 1'b0;
            z_mantissa_stage2<= 24'd0;

            special_nan      <= 1'b0;
            special_nan_out  <= 1'b0;
            special_inf      <= 1'b0;
            special_zero     <= 1'b0;

            round_increment  <= 1'b0;
            mantissa_rounded <= 25'd0;
        end else begin
            case (counter)
            3'd0: begin
                // Extract sign
                a_sign     <= a[31];
                b_sign     <= b[31];

                // Extract exponent
                a_exp      <= a[30:23];
                b_exp      <= b[30:23];

                // Extract mantissa with implicit 1 for normalized, else 0
                a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Detect zero inputs
                a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 23'd0);
                b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 23'd0);

                // Detect infinity inputs
                a_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 23'd0);
                b_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 23'd0);

                // Detect NaN inputs
                a_nan  <= (a[30:23] == 8'hFF) && (a[22:0] != 23'd0);
                b_nan  <= (b[30:23] == 8'hFF) && (b[22:0] != 23'd0);

                counter <= 3'd1;
            end

            3'd1: begin
                // Multiply mantissas (24x24 bits)
                product      <= a_mantissa * b_mantissa;

                // Compute sign of the result
                z_sign       <= a_sign ^ b_sign;

                // Add exponents and subtract bias
                exponent_sum <= a_exp + b_exp - EXP_BIAS;

                // Prepare special case flags for output later
                special_nan     <= a_nan || b_nan;
                // Inf*0 or 0*Inf is NaN
                special_nan_out <= ( (a_inf && b_zero) || (b_inf && a_zero) );
                special_inf     <= (a_inf || b_inf) && !special_nan_out;
                special_zero    <= (a_zero || b_zero) && !special_nan_out && !special_inf;

                counter <= 3'd2;
            end

            3'd2: begin
                // Normalize product:
                // If product MSB (bit 47) is 1, shift right by 1 and increment exponent by 1
                if (product[47] == 1'b1) begin
                    norm_product  <= product >> 1;
                    norm_exponent <= exponent_sum + 10'd1;
                end else begin
                    norm_product  <= product;
                    norm_exponent <= exponent_sum;
                end

                // Extract rounding bits (guard: bit 23, round: bit 22, sticky: OR bits 21..0)
                guard_bit  <= norm_product[23];
                round_bit  <= norm_product[22];
                sticky_bit <= |norm_product[21:0];

                // Extract 24 bits mantissa (including leading 1 bit)
                z_mantissa_stage2 <= norm_product[46:23];

                counter <= 3'd3;
            end

            3'd3: begin
                // Calculate round increment for round-to-nearest-even
                round_increment <= guard_bit && (round_bit || sticky_bit || z_mantissa_stage2[0]);

                // Add rounding increment to mantissa
                mantissa_rounded <= {1'b0, z_mantissa_stage2} + {24'd0, round_increment};

                // If rounding causes mantissa overflow, shift right by 1 and increment exponent
                if (mantissa_rounded[24] == 1'b1) begin
                    z_mantissa_stage2 <= mantissa_rounded[24:1];
                    norm_exponent <= norm_exponent + 10'd1;
                end else begin
                    z_mantissa_stage2 <= mantissa_rounded[23:0];
                    // exponent stays the same
                end

                // Compose output result with special cases and exponent overflow/underflow
                if (special_nan || special_nan_out) begin
                    // Quiet NaN: sign=0, exponent all ones, mantissa MSB=1 (quiet NaN bit)
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                end else if (special_inf) begin
                    // Infinity output
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (special_zero) begin
                    // Zero output
                    z <= {z_sign, 31'd0};
                end else if (norm_exponent >= 10'd255) begin
                    // Overflow to infinity
                    z <= {z_sign, 8'hFF, 23'd0};
                end else if (norm_exponent <= 10'd0) begin
                    // Underflow to zero (no subnormals handled)
                    z <= {z_sign, 31'd0};
                end else begin
                    // Normalized number output
                    // Exponent is 8 bits (take low bits)
                    // Mantissa excludes leading 1 bit (bit 23)
                    z <= {z_sign, norm_exponent[7:0], z_mantissa_stage2[22:0]};
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