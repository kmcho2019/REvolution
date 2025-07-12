module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;

    // Extracted fields
    reg a_sign, b_sign, z_sign;
    reg [9:0] a_exponent, b_exponent, z_exponent; // wider to hold exponent sums and adjustments
    reg [23:0] a_mantissa, b_mantissa, z_mantissa; // 24 bits including implicit leading 1

    reg [49:0] product; // 24x24 => 48 bits, 50 bits used for possible shifts & sticky

    // Rounding bits
    reg guard_bit, round_bit, sticky;

    // Internal signals for special cases
    reg a_is_zero, b_is_zero, a_is_inf, b_is_inf, a_is_nan, b_is_nan;
    reg result_is_nan, result_is_inf, result_is_zero;

    // Intermediate normalized mantissa and exponent after product normalization and rounding
    reg [24:0] normalized_mantissa; // one extra bit for rounding overflow
    reg [9:0] normalized_exponent;

    // Temporary variables for rounding
    reg [26:0] rounding_field; // contains mantissa + guard + round + sticky bits

    // Function to detect special values from input
    function is_nan;
        input [31:0] val;
        begin
            is_nan = ((val[30:23] == 8'hFF) && (|val[22:0] != 0));
        end
    endfunction

    function is_inf;
        input [31:0] val;
        begin
            is_inf = ((val[30:23] == 8'hFF) && (val[22:0] == 0));
        end
    endfunction

    function is_zero;
        input [31:0] val;
        begin
            is_zero = (val[30:0] == 0);
        end
    endfunction

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'b0;
            z <= 32'b0;
            a_sign <= 0; b_sign <= 0; z_sign <= 0;
            a_exponent <= 0; b_exponent <= 0; z_exponent <= 0;
            a_mantissa <= 0; b_mantissa <= 0; z_mantissa <= 0;
            product <= 0;
            guard_bit <= 0; round_bit <= 0; sticky <= 0;
            result_is_nan <= 0; result_is_inf <= 0; result_is_zero <= 0;
        end else begin
            case(counter)
                3'd0: begin
                    // Cycle 0: Extract fields and detect special cases
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_is_nan <= is_nan(a);
                    b_is_nan <= is_nan(b);
                    a_is_inf <= is_inf(a);
                    b_is_inf <= is_inf(b);
                    a_is_zero <= is_zero(a);
                    b_is_zero <= is_zero(b);

                    // Extract exponents and mantissas with implicit leading 1 for normalized
                    // If denormalized exponent (0), leading 1 is 0 and mantissa as is
                    // IEEE-754 single precision bias = 127
                    if (a[30:23] == 0) begin
                        // denormal number
                        a_exponent <= 0;
                        a_mantissa <= {1'b0, a[22:0]};
                    end else begin
                        a_exponent <= a[30:23];
                        a_mantissa <= {1'b1, a[22:0]};
                    end

                    if (b[30:23] == 0) begin
                        b_exponent <= 0;
                        b_mantissa <= {1'b0, b[22:0]};
                    end else begin
                        b_exponent <= b[30:23];
                        b_mantissa <= {1'b1, b[22:0]};
                    end

                    counter <= counter + 1;
                end

                3'd1: begin
                    // Cycle 1: Handle special cases and multiply mantissas, add exponents

                    // Handle special cases first
                    // NaN propagation
                    if (a_is_nan || b_is_nan) begin
                        result_is_nan <= 1;
                        result_is_inf <= 0;
                        result_is_zero <= 0;
                        z_sign <= 0; // NaN sign often 0
                        z_exponent <= 10'h1FF; // Max exponent to indicate NaN (all ones)
                        z_mantissa <= 24'h400000; // quiet NaN pattern with MSB of mantissa set
                        product <= 0;
                    end else if (a_is_inf || b_is_inf) begin
                        // Infinity times zero is NaN
                        if (a_is_inf && b_is_zero || b_is_inf && a_is_zero) begin
                            result_is_nan <= 1;
                            result_is_inf <= 0;
                            result_is_zero <= 0;
                            z_sign <= 0;
                            z_exponent <= 10'h1FF;
                            z_mantissa <= 24'h400000; // quiet NaN
                            product <= 0;
                        end else begin
                            // result is infinity, sign is xor of signs
                            result_is_nan <= 0;
                            result_is_inf <= 1;
                            result_is_zero <= 0;
                            z_sign <= a_sign ^ b_sign;
                            z_exponent <= 10'h1FF;
                            z_mantissa <= 0;
                            product <= 0;
                        end
                    end else if (a_is_zero || b_is_zero) begin
                        // Multiplying by zero gives zero, unless special cases above
                        result_is_zero <= 1;
                        result_is_nan <= 0;
                        result_is_inf <= 0;
                        z_sign <= a_sign ^ b_sign;
                        z_exponent <= 0;
                        z_mantissa <= 0;
                        product <= 0;
                    end else begin
                        // Normal multiplication

                        result_is_nan <= 0;
                        result_is_inf <= 0;
                        result_is_zero <= 0;

                        // Multiply mantissas: 24 bits x 24 bits = 48 bits product
                        product <= a_mantissa * b_mantissa;

                        // Add exponents, subtract bias 127 (bias for single-precision IEEE-754)
                        // Extend exponent to 10 bits to avoid overflow in addition/subtraction
                        z_exponent <= a_exponent + b_exponent - 8'd127;

                        // Sign of result is xor of input signs
                        z_sign <= a_sign ^ b_sign;
                    end

                    counter <= counter + 1;
                end

                3'd2: begin
                    // Cycle 2: Normalize product, generate rounding bits
                    if (result_is_nan || result_is_inf || result_is_zero) begin
                        // No normalization needed for special cases, just output directly
                        // z has been assembled partially at cycle 1
                        if (result_is_nan) begin
                            // z already set in cycle 1
                            z <= {z_sign, 8'hFF, z_mantissa[22:0] | 23'h400000}; // enforce qNaN pattern
                        end else if (result_is_inf) begin
                            z <= {z_sign, 8'hFF, 23'b0};
                        end else begin // zero
                            z <= {z_sign, 31'b0};
                        end
                        counter <= 0;
                    end else begin
                        // Normal result, normalize product mantissa and prepare for rounding

                        // product is 48 bits from 0 to 47, representing product of 24x24 bits.
                        // The product can be:
                        // - MSB = bit 47 might be 1 (if leading bits multiplied to >= 2.0), else 0.
                        // Normalization: if product[47] == 1, shift right by 1 and increment exponent
                        // else product is already normalized.

                        if (product[47] == 1'b1) begin
                            // Leading one at bit 47, shift right by 1 to get mantissa of 24 bits plus rounding bits
                            normalized_mantissa <= product[47:23]; // 25 bits: bits [47:23]
                            normalized_exponent <= z_exponent + 1;
                            // rounding bits: guard bit is bit 22, round bit bit 21, sticky bits or from bits 20 down to 0
                            guard_bit <= product[22];
                            round_bit <= product[21];
                            sticky <= |product[20:0];
                        end else begin
                            // Leading one at bit 46, no shift needed, mantissa bits [46:23]
                            normalized_mantissa <= product[46:22]; // 25 bits: bits [46:22]
                            normalized_exponent <= z_exponent;
                            guard_bit <= product[21];
                            round_bit <= product[20];
                            sticky <= |product[19:0];
                        end

                        counter <= counter + 1;
                    end
                end

                3'd3: begin
                    // Cycle 3: Rounding, exponent adjustment and output assembly

                    if (result_is_nan || result_is_inf || result_is_zero) begin
                        // Already handled cycle 2 output, just keep zero or special outputs stable
                        counter <= 0;
                    end else begin
                        // Round to nearest even

                        // Rounding logic:
                        // If guard bit = 1
                        //   If round_bit or sticky is 1, or mantissa LSB is 1 (tie break)
                        //      round up (add 1)
                        // Else no rounding

                        // normalized_mantissa is 25 bits (24 mantissa + 1 leading bit)
                        // mantissa for IEEE-754 is 23 bits fractional part, with implicit leading 1 bit removed in output
                        // so we need to round the mantissa here and handle possible overflow.

                        reg round_increment;
                        reg [24:0] rounded_mantissa;

                        round_increment = 0;
                        if (guard_bit) begin
                            if (round_bit | sticky) begin
                                round_increment = 1'b1;
                            end else if (normalized_mantissa[0] == 1'b1) begin
                                // tie break - round to even (LSB of mantissa is 1)
                                round_increment = 1'b1;
                            end
                        end

                        rounded_mantissa = normalized_mantissa + round_increment;

                        // Check overflow after rounding (carry out)
                        // If MSB bit 24 overflows, shift mantissa right and increment exponent
                        if (rounded_mantissa[24] == 1'b1) begin
                            // Mantissa overflowed
                            rounded_mantissa = rounded_mantissa >> 1;
                            normalized_exponent = normalized_exponent + 1;
                        end

                        // Handle exponent overflow and underflow
                        // Exponent is 8-bit biased field, range: 0..255, bias=127
                        if (normalized_exponent >= 10'd255) begin
                            // Overflow: output infinity
                            z <= {z_sign, 8'hFF, 23'b0};
                        end else if (normalized_exponent <= 0) begin
                            // Underflow: output zero (could implement gradual underflow but simplified here)
                            z <= {z_sign, 31'b0};
                        end else begin
                            // Normal output
                            z_exponent <= normalized_exponent[7:0];
                            z_mantissa <= rounded_mantissa[23:1]; // remove leading 1 implicit bit (bit 24 is MSB, bit 23 is hidden)
                            z <= {z_sign, normalized_exponent[7:0], rounded_mantissa[22:0]};
                        end

                        counter <= 0;
                    end
                end

                default: begin
                    counter <= 0;
                end
            endcase
        end
    end

endmodule