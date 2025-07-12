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
    reg [9:0] a_exponent, b_exponent;  // Use wider bitwidth for intermediate exponent calculation
    reg [23:0] a_mantissa, b_mantissa; // 24 bits to include implicit 1 if normalized

    // Intermediate signals
    reg product_sign;
    reg [9:0] product_exponent; // exponent sum - bias
    reg [49:0] product;         // 24x24 multiplication yields up to 48 bits, keep 50 bits for shifts & rounding

    // Normalized mantissa with leading one for normalized numbers, or 0 for denormals
    wire a_is_zero = (a[30:0] == 31'b0);
    wire b_is_zero = (b[30:0] == 31'b0);

    wire a_is_inf = (a[30:23] == 8'hFF) && (a[22:0] == 0);
    wire b_is_inf = (b[30:23] == 8'hFF) && (b[22:0] == 0);

    wire a_is_nan = (a[30:23] == 8'hFF) && (a[22:0] != 0);
    wire b_is_nan = (b[30:23] == 8'hFF) && (b[22:0] != 0);

    // Output components
    reg z_sign;
    reg [8:0] z_exp9; // 9 bits to handle exponent before clipping (max 510 after sum)
    reg [23:0] z_mantissa;

    // Rounding bits
    reg guard_bit, round_bit, sticky;

    // Internal registers to hold special flags for output stage
    reg special_nan;
    reg special_inf;
    reg special_zero;

    // Constants
    localparam BIAS = 127;

    // Temporary shifted product for normalization
    reg [49:0] product_norm;

    // Sticky bit calculation helper
    function sticky_bit_calc;
        input [24:0] bits;
        integer i;
        begin
            sticky_bit_calc = 0;
            for(i=0; i<25; i=i+1) begin
                if(bits[i])
                    sticky_bit_calc = 1;
            end
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 32'b0;
            a_sign <= 0; b_sign <= 0;
            a_exponent <= 0; b_exponent <= 0;
            a_mantissa <= 0; b_mantissa <= 0;
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
        end else begin
            case(counter)
                3'd0: begin
                    // Cycle 0: Extract sign, exponent, mantissa from inputs
                    counter <= 1;

                    a_sign <= a[31];
                    b_sign <= b[31];

                    a_exponent <= {2'b00, a[30:23]}; // extend to 10 bits for safety (max 255)
                    b_exponent <= {2'b00, b[30:23]};

                    // If exponent == 0 -> denormal, no implicit leading 1
                    // else implicit leading one at MSB of mantissa.
                    a_mantissa <= (a[30:23] == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Reset special flags for next cycle
                    special_nan <= 0;
                    special_inf <= 0;
                    special_zero <= 0;

                    z <= 32'b0;
                end
                3'd1: begin
                    // Cycle 1: Special case detection, sign and exponent addition, mantissa multiplication

                    counter <= 2;

                    // Special case handling: NaN or Infinity or zero detection
                    if (a_is_nan || b_is_nan) begin
                        special_nan <= 1;
                    end else if (a_is_inf || b_is_inf) begin
                        // Infinity * 0 = NaN
                        if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero))
                            special_nan <= 1;
                        else
                            special_inf <= 1;
                    end else if (a_is_zero || b_is_zero) begin
                        special_zero <= 1;
                    end

                    // Compute sign of product
                    product_sign <= a_sign ^ b_sign;

                    // Exponent sum and bias subtract (if both normal or denormal)
                    // For denormals exponent = 0, add bias as if exponent was 1 to exponent
                    // But since denormals treated as exponent = 0 and mantissa no implicit 1, exponent sum formula:
                    // product_exponent = (a_exp == 0 ? 1 : a_exp) + (b_exp == 0 ? 1 : b_exp) - bias

                    // Convert exponent to adjusted exponent with denormals as exponent=1 for calculation:
                    reg [9:0] adj_a_exp, adj_b_exp;
                    adj_a_exp = (a_exponent == 0) ? 10'd1 : a_exponent;
                    adj_b_exp = (b_exponent == 0) ? 10'd1 : b_exponent;

                    product_exponent <= adj_a_exp + adj_b_exp - BIAS;

                    // Multiply mantissas (24 bits * 24 bits)
                    product <= a_mantissa * b_mantissa;
                    // product is up to 48 bits, assign to 50 bits register (upper bits zero)
                    // We'll use product[47:0] actually

                end
                3'd2: begin
                    // Cycle 2: Normalize product, determine rounding bits

                    counter <= 3;

                    // Product is 48 bits (product[47:0]) stored in 50-bit reg (left padded zero)
                    // If MSB product[47] == 1: means product is of form 1.xxxx, normalized.
                    // else product is shifted left by one, exponent must be adjusted.

                    if (product[47] == 1) begin
                        // Normalized product, exponent stays same
                        product_norm = product;
                        product_exponent <= product_exponent + 1; // increment exponent because mantissa is now 1.xxx
                    end else begin
                        // Leading bit at 46 or less, shift left by 1 to normalize
                        product_norm = product << 1;
                        // exponent stays as is (already accounted for)
                    end

                    // Extract mantissa bits [46:24] -> 23 bits mantissa (bit 47 is implicit 1)
                    // We keep 24 bits mantissa including implicit bit for rounding, so bits 46 down to 23
                    z_mantissa <= product_norm[46:23]; // 24 bits mantissa including implicit bit

                    // Rounding bits
                    guard_bit <= product_norm[22];
                    round_bit <= product_norm[21];
                    // Sticky bit: OR of bits 20 down to 0
                    sticky <= |product_norm[20:0];
                end
                3'd3: begin
                    // Cycle 3: Round, handle overflow/underflow, produce output z

                    counter <= 0;

                    // Round to nearest even
                    // round up if (guard_bit & (round_bit | sticky)) or (guard_bit & least significant mantissa bit)
                    // The least significant mantissa bit is z_mantissa[0]
                    reg round_up;
                    round_up = 0;

                    round_up = (guard_bit && (round_bit || sticky)) || (guard_bit && !round_bit && !sticky && z_mantissa[0]);

                    reg [23:0] rounded_mantissa;
                    reg [9:0] rounded_exponent;

                    if (round_up) begin
                        {rounded_exponent, rounded_mantissa} = {product_exponent, z_mantissa} + 1;
                        // if mantissa overflows (1_00000000000000000000000) after rounding
                        if (rounded_mantissa[23] == 1 && z_mantissa[23] == 1) begin
                            // mantissa overflow, shift right and increment exponent
                            rounded_mantissa = rounded_mantissa >> 1;
                            rounded_exponent = rounded_exponent + 1;
                        end
                    end else begin
                        rounded_mantissa = z_mantissa;
                        rounded_exponent = product_exponent;
                    end

                    // Handle overflow and underflow
                    // If exponent after rounding is >= 255 => Infinity
                    // If exponent <= 0 => Denormal or zero

                    // Check special cases flags first
                    if (special_nan) begin
                        // Output a quiet NaN: sign 0, exponent all 1s, mantissa with MSB 1 to differentiate from Inf
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0};
                    end else if (special_inf) begin
                        // Output infinity with correct sign
                        z <= {product_sign, 8'hFF, 23'b0};
                    end else if (special_zero) begin
                        // Output zero with correct sign
                        z <= {product_sign, 31'b0};
                    end else begin
                        if (rounded_exponent >= 255) begin
                            // Overflow: set to infinity with sign
                            z <= {product_sign, 8'hFF, 23'b0};
                        end else if (rounded_exponent <= 0) begin
                            // Underflow: produce denormal or zero
                            // Shift mantissa right by (1 - exponent) to form denormal
                            // Only if exponent == 0 or negative
                            integer shift_amount;
                            reg [47:0] mantissa_with_hidden;
                            reg [47:0] shifted_mantissa;
                            shift_amount = 1 - rounded_exponent;

                            // Construct mantissa with implicit leading one at bit 23
                            mantissa_with_hidden = {1'b1, rounded_mantissa[22:0], 24'b0}; // 48 bits: 1.mantissa shifted 24 bits left for precision

                            // Shift right for denormal representation
                            if (shift_amount < 48)
                                shifted_mantissa = mantissa_with_hidden >> shift_amount;
                            else
                                shifted_mantissa = 0;

                            // Round denormal mantissa: take top 23 bits from shifted_mantissa[46:24]
                            // Extract rounding bits for denormals
                            guard_bit = shifted_mantissa[23];
                            round_bit = shifted_mantissa[22];
                            sticky = |shifted_mantissa[21:0];

                            rounded_mantissa = shifted_mantissa[46:24];

                            // Apply rounding again for denormals
                            round_up = (guard_bit && (round_bit || sticky)) || (guard_bit && !round_bit && !sticky && rounded_mantissa[0]);

                            if (round_up) begin
                                rounded_mantissa = rounded_mantissa + 1;
                            end

                            // If after rounding mantissa is zero, output zero
                            if (rounded_mantissa == 0) begin
                                z <= {product_sign, 31'b0};
                            end else begin
                                // Output denormal number
                                z <= {product_sign, 8'b0, rounded_mantissa[22:0]};
                            end
                        end else begin
                            // Normal number output
                            // Exponent is 8 bits
                            z <= {product_sign, rounded_exponent[7:0], rounded_mantissa[22:0]};
                        end
                    end

                end
            endcase
        end
    end

endmodule