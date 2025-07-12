module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);
    // Cycle counter
    reg [2:0] counter;

    // Decomposed input signals
    reg a_sign, b_sign;
    reg [9:0] a_exponent, b_exponent;  // Wider for intermediate calculations
    reg [23:0] a_mantissa, b_mantissa; // 24 bits with implicit 1 if normalized

    // Intermediate signals
    reg product_sign;
    reg [9:0] product_exponent; // exponent sum minus bias
    reg [49:0] product;         // 24x24 multiplication yields up to 48 bits, keep 50 bits for shifts & rounding

    // Output components
    reg z_sign;
    reg [8:0] z_exp9; // 9 bits to handle exponent before clipping (max 510 after sum)
    reg [23:0] z_mantissa;

    // Rounding bits
    reg guard_bit, round_bit, sticky;

    // Internal flags
    reg special_nan;
    reg special_inf;
    reg special_zero;

    // Constants
    localparam BIAS = 127;

    // Normalized product in cycle 2
    reg [49:0] product_norm;

    // Temporary registers for rounding
    reg round_up;
    reg [23:0] rounded_mantissa;
    reg [9:0] rounded_exponent;

    // For denormal handling
    reg [47:0] mantissa_with_hidden;
    reg [47:0] shifted_mantissa;
    reg [22:0] denorm_mantissa;
    reg denorm_guard, denorm_round, denorm_sticky;

    // Temporary for shift amount - declared at module scope to avoid illegal declaration inside always block
    integer shift_amount;

    // Wires for input special cases
    wire a_is_zero = (a[30:0] == 31'b0);
    wire b_is_zero = (b[30:0] == 31'b0);

    wire a_is_inf = (a[30:23] == 8'hFF) && (a[22:0] == 0);
    wire b_is_inf = (b[30:23] == 8'hFF) && (b[22:0] == 0);

    wire a_is_nan = (a[30:23] == 8'hFF) && (a[22:0] != 0);
    wire b_is_nan = (b[30:23] == 8'hFF) && (b[22:0] != 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 32'b0;

            a_sign <= 0;
            b_sign <= 0;
            a_exponent <= 0;
            b_exponent <= 0;
            a_mantissa <= 0;
            b_mantissa <= 0;

            product_sign <= 0;
            product_exponent <= 0;
            product <= 0;

            z_sign <= 0;
            z_exp9 <= 0;
            z_mantissa <= 0;

            guard_bit <= 0;
            round_bit <= 0;
            sticky <= 0;

            special_nan <= 0;
            special_inf <= 0;
            special_zero <= 0;

            product_norm <= 0;

            round_up <= 0;
            rounded_mantissa <= 0;
            rounded_exponent <= 0;

            mantissa_with_hidden <= 0;
            shifted_mantissa <= 0;
            denorm_mantissa <= 0;
            denorm_guard <= 0;
            denorm_round <= 0;
            denorm_sticky <= 0;

            shift_amount <= 0;
        end else begin
            case(counter)
                3'd0: begin
                    // Cycle 0: Extract sign, exponent, mantissa from inputs
                    counter <= 3'd1;

                    a_sign <= a[31];
                    b_sign <= b[31];

                    // Extend exponents to 10 bits for intermediate calculation, zero-extend MSBs
                    a_exponent <= {2'b00, a[30:23]};
                    b_exponent <= {2'b00, b[30:23]};

                    // Mantissa with implicit leading 1 if normalized exponent != 0, else leading 0 for denormal
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Reset special flags
                    special_nan <= 0;
                    special_inf <= 0;
                    special_zero <= 0;

                    z <= 32'b0;
                end

                3'd1: begin
                    // Cycle 1: Detect special cases, compute sign and exponent sum, multiply mantissas
                    counter <= 3'd2;

                    // Special cases handling
                    if (a_is_nan || b_is_nan) begin
                        special_nan <= 1'b1;
                    end else if (a_is_inf || b_is_inf) begin
                        // Infinity * 0 = NaN
                        if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                            special_nan <= 1'b1;
                        end else begin
                            special_inf <= 1'b1;
                        end
                    end else if (a_is_zero || b_is_zero) begin
                        special_zero <= 1'b1;
                    end else begin
                        special_nan <= 0;
                        special_inf <= 0;
                        special_zero <= 0;
                    end

                    // Compute sign of product
                    product_sign <= a_sign ^ b_sign;

                    // Adjust exponents for denormals: if zero exponent, treat exponent as 1 for calculation
                    // (denormal exponent treated as 1 for exponent calculation, mantissa no implicit bit)
                    reg [9:0] adj_a_exp;
                    reg [9:0] adj_b_exp;
                    adj_a_exp = (a_exponent == 0) ? 10'd1 : a_exponent;
                    adj_b_exp = (b_exponent == 0) ? 10'd1 : b_exponent;

                    product_exponent <= adj_a_exp + adj_b_exp - BIAS;

                    // Multiply mantissas (24 bits * 24 bits)
                    // product is up to 48 bits stored in lower bits of product (50 bits reg)
                    product <= a_mantissa * b_mantissa;
                end

                3'd2: begin
                    // Cycle 2: Normalize product and extract rounding bits
                    counter <= 3'd3;

                    if (product[47] == 1'b1) begin
                        // Already normalized (1.xxx)
                        product_norm <= product;
                        // When product MSB is 1 at bit 47, increment exponent by 1
                        product_exponent <= product_exponent + 1;
                    end else begin
                        // Leading bit is 0, shift left by 1 to normalize
                        product_norm <= product << 1;
                        // Exponent stays unchanged
                        // product_exponent unchanged
                    end

                    // Extract 24 bits mantissa including implicit leading bit (bit 46 downto 23)
                    z_mantissa <= product_norm[46:23];

                    // Extract rounding bits: guard bit (bit 22), round bit (bit 21), sticky bit (OR of bits 20 downto 0)
                    guard_bit <= product_norm[22];
                    round_bit <= product_norm[21];
                    sticky <= |product_norm[20:0];
                end

                3'd3: begin
                    // Cycle 3: Round mantissa, handle overflow/underflow and produce final output
                    counter <= 3'd0;

                    // Round to nearest even
                    // round up if (guard & (round | sticky)) or (guard & !round & !sticky & lsb of mantissa)
                    round_up <= (guard_bit && (round_bit || sticky)) || (guard_bit && !round_bit && !sticky && z_mantissa[0]);

                    if (round_up) begin
                        // Add 1 to mantissa, handle carry-out to exponent if mantissa overflows
                        {rounded_exponent, rounded_mantissa} <= {product_exponent, z_mantissa} + 1'b1;

                        // Check mantissa overflow: if mantissa MSB (bit 23) changed from 0 to 1 and previous was 1, overflow occurred
                        if (rounded_mantissa[23] == 1'b1 && z_mantissa[23] == 1'b1) begin
                            // Mantissa overflow: shift right by 1 and increment exponent
                            rounded_mantissa <= rounded_mantissa >> 1;
                            rounded_exponent <= rounded_exponent + 1'b1;
                        end
                    end else begin
                        rounded_mantissa <= z_mantissa;
                        rounded_exponent <= product_exponent;
                    end

                    // Handle special cases first
                    if (special_nan) begin
                        // Quiet NaN: sign 0, exponent all 1s, mantissa MSB 1 (quiet bit), rest zero
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0};
                    end else if (special_inf) begin
                        // Infinity with correct sign
                        z <= {product_sign, 8'hFF, 23'b0};
                    end else if (special_zero) begin
                        // Zero with correct sign
                        z <= {product_sign, 31'b0};
                    end else begin
                        // Handle normal overflow and underflow cases
                        if (rounded_exponent >= 255) begin
                            // Overflow -> Infinity
                            z <= {product_sign, 8'hFF, 23'b0};
                        end else if (rounded_exponent <= 0) begin
                            // Underflow -> produce denormal or zero
                            shift_amount = 1 - rounded_exponent;

                            // Compose mantissa with implicit leading 1 at bit 23, shifted left 24 bits for precision
                            mantissa_with_hidden = {1'b1, rounded_mantissa[22:0], 24'b0}; // 48 bits total

                            if (shift_amount < 48)
                                shifted_mantissa = mantissa_with_hidden >> shift_amount;
                            else
                                shifted_mantissa = 0;

                            // Extract denormal mantissa bits [46:24] (23 bits)
                            denorm_mantissa = shifted_mantissa[46:24];

                            // Extract rounding bits for denormals
                            denorm_guard = shifted_mantissa[23];
                            denorm_round = shifted_mantissa[22];
                            denorm_sticky = |shifted_mantissa[21:0];

                            // Round denormal mantissa
                            round_up <= (denorm_guard && (denorm_round || denorm_sticky)) || (denorm_guard && !denorm_round && !denorm_sticky && denorm_mantissa[0]);

                            if (round_up)
                                denorm_mantissa <= denorm_mantissa + 1;

                            // If after rounding mantissa is zero, output zero
                            if (denorm_mantissa == 0) begin
                                z <= {product_sign, 31'b0};
                            end else begin
                                // Output denormal number
                                z <= {product_sign, 8'b0, denorm_mantissa};
                            end
                        end else begin
                            // Normal number output
                            // Exponent is 8 bits
                            z <= {product_sign, rounded_exponent[7:0], rounded_mantissa[22:0]};
                        end
                    end
                end

                default: begin
                    counter <= 3'd0;
                end
            endcase
        end
    end

endmodule