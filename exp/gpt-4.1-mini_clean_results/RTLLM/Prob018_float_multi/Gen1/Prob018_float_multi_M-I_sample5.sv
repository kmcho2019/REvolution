module float_multi (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  z
);

    // Parameters for IEEE-754 single precision
    localparam BIAS       = 127;
    localparam EXP_MAX    = 8'hFF;
    localparam EXP_INF    = 8'hFF;
    localparam EXP_ZERO   = 8'h00;
    localparam MANT_BITS  = 23;
    localparam FULL_MANT  = 24; // including hidden 1

    // FSM counter for steps
    reg [2:0] counter;

    // Extracted fields registers
    reg a_sign, b_sign, z_sign;
    reg [9:0] a_exp_unbiased, b_exp_unbiased, z_exp_unbiased; // 10 bits signed range for exponent calculations
    reg [7:0] a_exp_field, b_exp_field;
    reg [23:0] a_mantissa, b_mantissa;   // 24 bits including implicit leading 1 if normalized
    reg [23:0] z_mantissa;                // 24 bits mantissa including leading 1

    // Intermediate signals for special cases
    reg a_is_nan, b_is_nan;
    reg a_is_inf, b_is_inf;
    reg a_is_zero, b_is_zero;

    // Product of mantissas: 24 x 24 => 48 bits
    reg [47:0] product;                  

    // Normalized product (shifted if needed)
    reg [47:0] norm_product;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Temporary signals
    reg product_msb;

    // Combinational wires for mantissa multiplication and exponent addition
    wire [47:0] mant_product = a_mantissa * b_mantissa;
    wire signed [9:0] exp_sum = a_exp_unbiased + b_exp_unbiased;

    // Sticky bit calculation
    function automatic bit sticky_bit_calc;
        input [21:0] bits;
        integer i;
        begin
            sticky_bit_calc = 0;
            for (i = 0; i < 22; i = i + 1)
                sticky_bit_calc = sticky_bit_calc | bits[i];
        end
    endfunction

    // Reset and FSM sequential logic
    always @(posedge clk) begin
        if (rst) begin
            counter         <= 3'd0;
            z               <= 32'd0;

            a_sign          <= 1'b0;
            b_sign          <= 1'b0;
            z_sign          <= 1'b0;

            a_exp_unbiased  <= 10'd0;
            b_exp_unbiased  <= 10'd0;
            z_exp_unbiased  <= 10'd0;

            a_exp_field     <= 8'd0;
            b_exp_field     <= 8'd0;

            a_mantissa      <= 24'd0;
            b_mantissa      <= 24'd0;
            z_mantissa      <= 24'd0;

            product         <= 48'd0;
            norm_product    <= 48'd0;

            guard_bit       <= 1'b0;
            round_bit       <= 1'b0;
            sticky_bit      <= 1'b0;

            a_is_nan        <= 1'b0;
            b_is_nan        <= 1'b0;
            a_is_inf        <= 1'b0;
            b_is_inf        <= 1'b0;
            a_is_zero       <= 1'b0;
            b_is_zero       <= 1'b0;
            product_msb     <= 1'b0;
        end else begin
            case (counter)
                3'd0: begin
                    // Extract sign bits
                    a_sign      <= a[31];
                    b_sign      <= b[31];

                    // Extract exponent fields
                    a_exp_field <= a[30:23];
                    b_exp_field <= b[30:23];

                    // Extract special cases for a
                    a_is_nan    <= (a[30:23] == EXP_INF) && (|a[22:0]);
                    a_is_inf    <= (a[30:23] == EXP_INF) && (~|a[22:0]);
                    a_is_zero   <= (a[30:0] == 31'd0);

                    // Extract special cases for b
                    b_is_nan    <= (b[30:23] == EXP_INF) && (|b[22:0]);
                    b_is_inf    <= (b[30:23] == EXP_INF) && (~|b[22:0]);
                    b_is_zero   <= (b[30:0] == 31'd0);

                    // Prepare mantissas
                    if (a[30:23] == EXP_ZERO)
                        a_mantissa <= {1'b0, a[22:0]}; // denorm or zero: no hidden 1
                    else
                        a_mantissa <= {1'b1, a[22:0]}; // normalized: implicit leading 1

                    if (b[30:23] == EXP_ZERO)
                        b_mantissa <= {1'b0, b[22:0]};
                    else
                        b_mantissa <= {1'b1, b[22:0]};

                    counter    <= 3'd1;
                end

                3'd1: begin
                    // Determine sign of result
                    z_sign <= a_sign ^ b_sign;

                    // Handle special cases:
                    if (a_is_nan || b_is_nan) begin
                        // Result is NaN
                        // Quiet NaN: exp=255, mantissa MSB=1 (bit22), rest zero
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        counter <= 3'd7;
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        counter <= 3'd7;
                    end else if (a_is_inf || b_is_inf) begin
                        // Inf * finite(non-zero) = Inf
                        z <= {z_sign, 8'hFF, 23'd0};
                        counter <= 3'd7;
                    end else if (a_is_zero || b_is_zero) begin
                        // zero * anything = zero
                        z <= {z_sign, 31'd0};
                        counter <= 3'd7;
                    end else begin
                        // Normal or denormal numbers
                        // Calculate unbiased exponents:
                        // denorm: exponent = 1 - bias = -126
                        a_exp_unbiased <= (a_exp_field == 0) ? (10'd1 - BIAS) : (a_exp_field - BIAS);
                        b_exp_unbiased <= (b_exp_field == 0) ? (10'd1 - BIAS) : (b_exp_field - BIAS);
                        counter        <= 3'd2;
                    end
                end

                3'd2: begin
                    // Mantissa multiplication
                    product        <= mant_product;
                    // Sum exponents (already calculated in wire exp_sum)
                    z_exp_unbiased <= exp_sum;
                    counter        <= 3'd3;
                end

                3'd3: begin
                    // Normalization:
                    // product range: multiply two [1,2) numbers -> [1,4)
                    // Check if product MSB (bit 47) is 1 (means >= 2)
                    product_msb <= product[47];
                    if (product[47]) begin
                        // Shift right by 1, increase exponent
                        norm_product   <= product >> 1;
                        z_exp_unbiased <= z_exp_unbiased + 1;
                    end else begin
                        norm_product <= product;
                        // exponent unchanged
                    end
                    counter <= 3'd4;
                end

                3'd4: begin
                    // Extract mantissa and rounding bits:
                    // Mantissa bits: norm_product[46:24] (23 bits mantissa)
                    // Guard bit: norm_product[23]
                    // Round bit: norm_product[22]
                    // Sticky bit: OR of norm_product[21:0]

                    z_mantissa <= norm_product[46:24];

                    guard_bit  <= norm_product[23];
                    round_bit  <= norm_product[22];
                    sticky_bit <= |norm_product[21:0];

                    counter <= 3'd5;
                end

                3'd5: begin
                    // Rounding to nearest even
                    // Condition to add 1 to mantissa:
                    // guard_bit == 1 and (round_bit == 1 or sticky_bit ==1 or LSB of mantissa == 1)
                    if (guard_bit && (round_bit || sticky_bit || z_mantissa[0])) begin
                        z_mantissa <= z_mantissa + 1;

                        // Check for mantissa overflow (24 bits)
                        if (z_mantissa == 24'hFFFFFF) begin
                            // Mantissa overflow, shift right by 1 and increment exponent
                            z_mantissa <= 24'h800000; // Bit 23 = 1, rest zero
                            z_exp_unbiased <= z_exp_unbiased + 1;
                        end
                    end

                    counter <= 3'd6;
                end

                3'd6: begin
                    // Assemble final output:

                    // Convert unbiased exponent to biased
                    // biased_exp = z_exp_unbiased + BIAS
                    // Handle overflow and underflow:

                    // Calculate biased exponent as integer for easy comparison
                    // Use signed integer for range check

                    integer biased_exp_int;
                    biased_exp_int = z_exp_unbiased + BIAS;

                    if (biased_exp_int >= 255) begin
                        // Overflow -> infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (biased_exp_int <= 0) begin
                        // Underflow -> zero (denormals ignored for simplicity)
                        // Optionally could implement gradual underflow
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal number
                        z <= {z_sign, biased_exp_int[7:0], z_mantissa[22:0]};
                    end

                    counter <= 3'd7;
                end

                3'd7: begin
                    // Hold output stable until reset
                    counter <= 3'd7;
                end

                default: counter <= 3'd0;
            endcase
        end
    end

endmodule