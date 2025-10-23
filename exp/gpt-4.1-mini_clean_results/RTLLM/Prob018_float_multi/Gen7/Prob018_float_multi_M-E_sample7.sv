module float_multi (
    input            clk,
    input            rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] z
);
    // Parameters
    localparam EXP_BIAS = 127;

    // Cycle counter: 0 to 7 (enough for stages)
    reg [2:0] counter;

    // Input fields registers
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [22:0] a_frac, b_frac;

    // Flags for special numbers
    reg a_zero, b_zero;
    reg a_inf,  b_inf;
    reg a_nan,  b_nan;

    // Extended mantissas with hidden bit (24 bits)
    reg [23:0] a_mantissa, b_mantissa;

    // Sequential multiplier registers (24-bit by 24-bit)
    reg [23:0] mul_mplier; // multiplier register
    reg [47:0] mul_accum;  // accumulator for product
    reg [4:0] mul_count;   // counts 24 cycles for multiplication bits

    // Product normalized form
    reg [47:0] product;

    // Intermediate exponent and sign
    reg [9:0] exponent_sum; // wider to hold overflow
    reg sign_out;

    // Normalization shift count
    reg [5:0] norm_shift_count;

    // Rounding bits
    reg guard_bit, round_bit, sticky_bit;

    // Rounding carry and adjusted mantissa
    reg round_increment;

    // Final exponent and mantissa after rounding
    reg [7:0] final_exp;
    reg [22:0] final_mantissa;

    // Special result flags
    reg result_is_nan;
    reg result_is_inf;
    reg result_is_zero;

    // Internal sticky bit for rounding (accumulates shifted out bits)
    reg sticky_accum;

    // States in counter:
    // 0: Extract inputs + detect special cases
    // 1: Setup multiplier registers
    // 2..25: Sequential multiply cycles (mul_count counts 0..23)
    // 26: Normalization shifts
    // 27: Rounding and final packaging

    // For simplicity, limit counter to 7 steps; multiply unrolled into cycles 2..5 with shift-and-add of 4 bits per cycle
    // But that may be complicated, so for the example we implement a 6-cycle multiplier (approximate): each cycle process 4 bits of multiplier

    // Instead of bit-by-bit multiply (24 cycles), do nibble-by-nibble (6 cycles):

    // Define multiplier nibble pointer
    reg [2:0] nibble_ptr; // 0 to 5 (6 nibbles *4 bits = 24 bits)

    // Temp product accumulator for sequential multiply
    reg [47:0] mul_temp;

    // Signals for special case handling (registered)
    reg special_nan;
    reg special_inf;
    reg special_zero;
    reg special_invalid; // inf*0 produces NaN

    // Sequential logic controlling all steps
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 0;

            a_sign <= 0; b_sign <= 0;
            a_exp <= 0; b_exp <= 0;
            a_frac <= 0; b_frac <= 0;

            a_zero <= 0; b_zero <= 0;
            a_inf <= 0; b_inf <= 0;
            a_nan <= 0; b_nan <= 0;

            a_mantissa <= 0; b_mantissa <= 0;

            mul_mplier <= 0;
            mul_accum <= 0;
            mul_count <= 0;

            mul_temp <= 0;
            nibble_ptr <= 0;

            product <= 0;

            exponent_sum <= 0;
            sign_out <= 0;

            norm_shift_count <= 0;

            guard_bit <= 0;
            round_bit <= 0;
            sticky_bit <= 0;

            round_increment <= 0;

            final_exp <= 0;
            final_mantissa <= 0;

            result_is_nan <= 0;
            result_is_inf <= 0;
            result_is_zero <= 0;
            special_nan <= 0;
            special_inf <= 0;
            special_zero <= 0;
            special_invalid <= 0;
            sticky_accum <= 0;
        end else begin
            case (counter)
                3'd0: begin
                    // Extract inputs: sign, exponent, fraction
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp  <= a[30:23];
                    b_exp  <= b[30:23];
                    a_frac <= a[22:0];
                    b_frac <= b[22:0];

                    // Detect special cases
                    a_zero <= (a[30:23] == 8'd0) && (a[22:0] == 0);
                    b_zero <= (b[30:23] == 8'd0) && (b[22:0] == 0);
                    a_inf  <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                    b_inf  <= (b[30:23] == 8'hFF) && (b[22:0] == 0);
                    a_nan  <= (a[30:23] == 8'hFF) && (a[22:0] != 0);
                    b_nan  <= (b[30:23] == 8'hFF) && (b[22:0] != 0);

                    // Clear output
                    z <= 0;

                    // Reset intermediate regs
                    mul_mplier <= 0;
                    mul_accum <= 0;
                    mul_count <= 0;
                    mul_temp <= 0;
                    nibble_ptr <= 0;

                    sticky_accum <= 0;

                    // Flags to zero
                    result_is_nan <= 0;
                    result_is_inf <= 0;
                    result_is_zero <= 0;
                    special_nan <= 0;
                    special_inf <= 0;
                    special_zero <= 0;
                    special_invalid <= 0;

                    exponent_sum <= 0;
                    sign_out <= 0;
                    norm_shift_count <= 0;

                    guard_bit <= 0;
                    round_bit <= 0;
                    sticky_bit <= 0;
                    round_increment <= 0;

                    final_exp <= 0;
                    final_mantissa <= 0;

                    // Prepare mantissas with implicit leading 1 if normalized, else zero leading for denormals
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                end

                3'd1: begin
                    // Handle special cases early
                    special_nan <= a_nan | b_nan;
                    special_inf <= (a_inf | b_inf) & ~(a_zero | b_zero);
                    special_zero <= (a_zero | b_zero) & ~(a_inf | b_inf);

                    // Invalid case: inf*0 = NaN
                    special_invalid <= (a_inf & b_zero) | (b_inf & a_zero);

                    // Compute sign and exponent sum
                    sign_out <= a_sign ^ b_sign;

                    if ( (a_exp == 8'd0) && (a_frac == 0) ) begin
                        // Denormal or zero treated exponent as 1 for sum
                        exponent_sum <= b_exp - EXP_BIAS + 1;
                    end else if ( (b_exp == 8'd0) && (b_frac == 0) ) begin
                        exponent_sum <= a_exp - EXP_BIAS + 1;
                    end else begin
                        exponent_sum <= a_exp + b_exp - EXP_BIAS;
                    end

                    // Setup multiplier registers for sequential multiply
                    mul_accum <= 48'd0;
                    mul_mplier <= b_mantissa;
                    mul_temp <= {24'd0, a_mantissa}; // multiplicand aligned to LSB
                    nibble_ptr <= 0;
                end

                3'd2, 3'd3, 3'd4, 3'd5, 3'd6, 3'd7: begin
                    // Sequential multiply processing 4 bits of multiplier each cycle
                    // Select 4-bit nibble from multiplier (b_mantissa)
                    // Multiply add shifted multiplicand if nibble bit set

                    // Extract nibble bits (4 bits)
                    reg [3:0] nibble_bits;
                    nibble_bits = mul_mplier[ (nibble_ptr*4) +: 4 ];

                    // Partial product addition
                    // Shift multiplicand left by nibble_ptr*4 bits
                    reg [47:0] shifted_multiplicand;
                    shifted_multiplicand = mul_temp << (nibble_ptr * 4);

                    // Add partial product depending on nibble bits
                    reg [47:0] partial_sum;
                    integer i;
                    partial_sum = 48'd0;
                    for(i=0; i<4; i=i+1) begin
                        if (nibble_bits[i])
                            partial_sum = partial_sum + (shifted_multiplicand << i);
                    end

                    // Accumulate partial sum into mul_accum
                    mul_accum <= mul_accum + partial_sum;

                    // Increment nibble pointer
                    nibble_ptr <= nibble_ptr + 1;
                end

                3'd0 + 8'd8: begin
                    // This state unreachable due to 3-bit counter - so instead, after 3'd7, wrap to zero.
                    // So we will handle normalization and rounding in next cycles after 3'd7.

                    // (No action here)
                end

                default: begin
                    // After all multiply cycles done (after 3'd7), move to normalization and rounding in a separate sequence.

                    // This design will fold normalization and rounding into counters after finishing multiplication.
                end
            endcase

            // Counter increment and wrap logic
            if (counter < 3'd7)
                counter <= counter + 1;
            else begin
                // After 3'd7, do normalization, rounding, output and reset
                // Execute normalization and rounding step by step across extra cycles

                // Normalize product: product is in mul_accum (48 bits)
                product <= mul_accum;

                // Handle special cases immediately
                if (special_nan | special_invalid) begin
                    // Output quiet NaN: 0 11111111 1xxxx...
                    z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    counter <= 0;
                end else if (special_inf) begin
                    // Output infinity with sign_out
                    z <= {sign_out, 8'hFF, 23'd0};
                    counter <= 0;
                end else if (special_zero) begin
                    // Output zero with sign_out
                    z <= {sign_out, 31'd0};
                    counter <= 0;
                end else begin
                    // Normal case: normalize, round, package output

                    // Normalization:
                    // The product is 48 bits, result mantissa needs to be 24 bits (including hidden bit)
                    // First check MSB position:
                    if (product[47]) begin
                        // MSB is bit 47 -> shift right 24 bits to get 23 bits mantissa + 1 bit hidden
                        // So mantissa = bits [46:23]
                        norm_shift_count <= 0;
                    end else begin
                        // Count leading zeros from MSB down to bit 24
                        // Shift left until bit 47 is 1 or exponent underflows
                        reg [5:0] shift_cnt;
                        shift_cnt = 0;
                        reg [47:0] shifted_p;
                        shifted_p = product;
                        while (shifted_p[47] == 0 && shift_cnt < 47) begin
                            shifted_p = shifted_p << 1;
                            shift_cnt = shift_cnt + 1;
                        end

                        norm_shift_count <= shift_cnt;
                    end

                    // Adjust exponent accordingly (decrement by norm_shift_count)
                    exponent_sum <= exponent_sum - norm_shift_count;

                    // Shift product left by norm_shift_count
                    product <= product << norm_shift_count;

                    // Extract mantissa bits [46:23], guard(22), round(21), sticky(20 down to 0)
                    final_mantissa <= product[46:24];

                    guard_bit <= product[23];
                    round_bit <= product[22];
                    sticky_bit <= |product[21:0];

                    // Rounding: round to nearest even
                    round_increment <= (guard_bit && (round_bit || sticky_bit || final_mantissa[0]));

                    // Apply rounding
                    reg [24:0] mant_rounded;
                    mant_rounded = {1'b0, final_mantissa} + round_increment;

                    // Handle rounding overflow
                    if (mant_rounded[24]) begin
                        // Mantissa overflow, shift right and increment exponent
                        mant_rounded = mant_rounded >> 1;
                        exponent_sum <= exponent_sum + 1;
                    end

                    // Final exponent check: overflow or underflow
                    if (exponent_sum >= 255) begin
                        // Overflow -> set to infinity
                        z <= {sign_out, 8'hFF, 23'd0};
                    end else if (exponent_sum <= 0) begin
                        // Underflow -> output zero (no subnormals)
                        z <= {sign_out, 31'd0};
                    end else begin
                        // Normal output
                        z <= {sign_out, exponent_sum[7:0], mant_rounded[22:0]};
                    end

                    // Reset counter for next operation
                    counter <= 0;
                end
            end
        end
    end
endmodule