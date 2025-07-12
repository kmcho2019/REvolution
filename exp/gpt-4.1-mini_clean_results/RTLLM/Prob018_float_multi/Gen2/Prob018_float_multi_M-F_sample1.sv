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
    localparam EXP_ZERO   = 8'h00;
    localparam MANT_BITS  = 23;
    localparam FULL_MANT  = 24; // including hidden leading 1

    // FSM counter for sequencing steps
    reg [2:0] counter;

    // Extracted fields
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exp_field, b_exp_field;
    reg signed [9:0] a_exp_unbiased, b_exp_unbiased, z_exp_unbiased; // to hold intermediate exponents with sign

    reg [23:0] a_mantissa, b_mantissa;   // 24 bits mantissa including implicit leading 1 if normalized
    reg [23:0] z_mantissa;

    // Special case flags
    reg a_is_nan, b_is_nan;
    reg a_is_inf, b_is_inf;
    reg a_is_zero, b_is_zero;

    // Mantissa product: 24x24=48 bits
    reg [47:0] product;

    // Normalized product and rounding bits
    reg [47:0] norm_product;
    reg guard_bit, round_bit, sticky_bit;

    // Mantissa product combinational wire
    wire [47:0] mant_product = a_mantissa * b_mantissa;
    // Exponent sum wire
    wire signed [9:0] exp_sum = a_exp_unbiased + b_exp_unbiased;

    // Sticky bit function (OR reduction)
    function automatic sticky_bit_calc;
        input [21:0] bits;
        integer i;
        begin
            sticky_bit_calc = 1'b0;
            for (i=0; i<22; i=i+1)
                sticky_bit_calc = sticky_bit_calc | bits[i];
        end
    endfunction

    // Sequential logic and FSM
    always @(posedge clk) begin
        if (rst) begin
            counter         <= 3'd0;
            z               <= 32'd0;

            a_sign          <= 1'b0;
            b_sign          <= 1'b0;
            z_sign          <= 1'b0;

            a_exp_field     <= 8'd0;
            b_exp_field     <= 8'd0;
            a_exp_unbiased  <= 10'd0;
            b_exp_unbiased  <= 10'd0;
            z_exp_unbiased  <= 10'd0;

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
        end else begin
            case (counter)
                3'd0: begin
                    // Extract sign and exponent fields
                    a_sign      <= a[31];
                    b_sign      <= b[31];

                    a_exp_field <= a[30:23];
                    b_exp_field <= b[30:23];

                    // Extract special cases for a
                    a_is_nan    <= (a[30:23] == EXP_MAX) && (|a[22:0]);
                    a_is_inf    <= (a[30:23] == EXP_MAX) && (~|a[22:0]);
                    a_is_zero   <= (a[30:0] == 31'd0);

                    // Extract special cases for b
                    b_is_nan    <= (b[30:23] == EXP_MAX) && (|b[22:0]);
                    b_is_inf    <= (b[30:23] == EXP_MAX) && (~|b[22:0]);
                    b_is_zero   <= (b[30:0] == 31'd0);

                    // Prepare mantissas with implicit leading 1 if normalized
                    // For denormals or zero, no implicit leading 1
                    a_mantissa <= (a[30:23] == EXP_ZERO) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == EXP_ZERO) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    counter <= 3'd1;
                end

                3'd1: begin
                    // Determine result sign
                    z_sign <= a_sign ^ b_sign;

                    // Special cases handling:
                    if (a_is_nan || b_is_nan) begin
                        // NaN result: propagate a quiet NaN, keep sign as 0 for standard NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0}; // quiet NaN: exp=255, mantissa MSB=1
                        counter <= 3'd7; // finish
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                        counter <= 3'd7;
                    end else if (a_is_inf || b_is_inf) begin
                        // Inf * non-zero finite = Inf with sign
                        z <= {z_sign, 8'hFF, 23'd0};
                        counter <= 3'd7;
                    end else if (a_is_zero || b_is_zero) begin
                        // zero * anything = zero with sign
                        z <= {z_sign, 31'd0};
                        counter <= 3'd7;
                    end else begin
                        // Normal or denormal inputs: compute unbiased exponents
                        // Denormal exponent treated as 1 - bias per IEEE754
                        a_exp_unbiased <= (a_exp_field == 0) ? (10'd1 - BIAS) : (a_exp_field - BIAS);
                        b_exp_unbiased <= (b_exp_field == 0) ? (10'd1 - BIAS) : (b_exp_field - BIAS);
                        counter <= 3'd2;
                    end
                end

                3'd2: begin
                    // Mantissa multiplication
                    product <= mant_product;

                    // Sum exponents now
                    z_exp_unbiased <= exp_sum;
                    counter <= 3'd3;
                end

                3'd3: begin
                    // Normalization:
                    // product range is [1,4)
                    // If MSB product[47] == 1, product is >= 2, shift right and increment exponent
                    if (product[47]) begin
                        norm_product <= product >> 1;
                        z_exp_unbiased <= z_exp_unbiased + 1;
                    end else begin
                        norm_product <= product;
                        // exponent unchanged
                    end
                    counter <= 3'd4;
                end

                3'd4: begin
                    // Extract mantissa and rounding bits
                    // Mantissa: norm_product[46:24] (23 bits)
                    // Guard bit: norm_product[23]
                    // Round bit: norm_product[22]
                    // Sticky bit: OR reduction of norm_product[21:0]

                    z_mantissa <= norm_product[46:24];
                    guard_bit  <= norm_product[23];
                    round_bit  <= norm_product[22];
                    sticky_bit <= |norm_product[21:0];

                    counter <= 3'd5;
                end

                3'd5: begin
                    // Rounding to nearest even:
                    // Round if guard_bit == 1 and (round_bit == 1 or sticky_bit == 1 or LSB of mantissa == 1)
                    if (guard_bit && (round_bit || sticky_bit || z_mantissa[0])) begin
                        {z_mantissa, z_exp_unbiased} <= (z_mantissa == 24'hFFFFFF) ? 
                            // Mantissa overflow: shift mantissa right by 1 (=> 0x800000), increment exponent
                            {24'h800000, z_exp_unbiased + 1} :
                            // No overflow: just add 1
                            {z_mantissa + 1, z_exp_unbiased};
                    end
                    // else no rounding

                    counter <= 3'd6;
                end

                3'd6: begin
                    // Assemble final output:

                    // Compute biased exponent
                    // Clamp exponent in [0..255] range for output
                    // Handle overflow -> infinity; underflow -> zero (no gradual denormals)

                    reg [8:0] biased_exp; // 9 bits to detect overflow

                    biased_exp = z_exp_unbiased + BIAS;

                    if (biased_exp >= 9'd255) begin
                        // Overflow -> infinity
                        z <= {z_sign, 8'hFF, 23'd0};
                    end else if (biased_exp <= 0) begin
                        // Underflow -> zero (gradual underflow ignored)
                        z <= {z_sign, 31'd0};
                    end else begin
                        // Normal number
                        z <= {z_sign, biased_exp[7:0], z_mantissa[22:0]};
                    end

                    counter <= 3'd7;
                end

                3'd7: begin
                    // Hold output stable; allow restart next cycle
                    // Wrap counter to zero to accept new inputs continuously
                    counter <= 3'd0;
                end

                default: counter <= 3'd0;
            endcase
        end
    end

endmodule