module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Internal registers
    reg [2:0] counter;

    reg a_sign, b_sign, z_sign;
    reg [9:0] a_exponent, b_exponent, z_exponent; // using 10 bits to handle exponent + intermediate adjustments
    reg [23:0] a_mantissa, b_mantissa; // 24 bits including the implicit leading 1
    reg [49:0] product; // 24 x 24 multiplication result max 48 bits, 50 bits width reserved
    reg [23:0] z_mantissa;

    reg guard_bit, round_bit, sticky;

    // Flags for special cases
    reg a_nan, b_nan;
    reg a_inf, b_inf;
    reg a_zero, b_zero;

    // temp signals for normalization and rounding
    reg [6:0] shift_amount; // max shift needed for normalization
    reg [49:0] norm_product;
    reg [49:0] product_shifted;
    reg product_msb; // MSB of product for normalization decision

    // Internal states for FSM steps
    // 0: idle/reset
    // 1: extract fields + check special cases
    // 2: handle special cases or prepare multiplication
    // 3: multiply mantissas and add exponents
    // 4: normalize product
    // 5: rounding and final adjust exponent
    // 6: assemble output
    // 7: done/hold

    always @(posedge clk) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'b0;
            a_sign <= 1'b0;
            b_sign <= 1'b0;
            z_sign <= 1'b0;
            a_exponent <= 10'b0;
            b_exponent <= 10'b0;
            z_exponent <= 10'b0;
            a_mantissa <= 24'b0;
            b_mantissa <= 24'b0;
            z_mantissa <= 24'b0;
            product <= 50'b0;
            guard_bit <= 1'b0;
            round_bit <= 1'b0;
            sticky <= 1'b0;
            a_nan <= 1'b0;
            b_nan <= 1'b0;
            a_inf <= 1'b0;
            b_inf <= 1'b0;
            a_zero <= 1'b0;
            b_zero <= 1'b0;
            shift_amount <= 7'b0;
        end else begin
            case (counter)
                3'd0: begin
                    // Start operation: capture inputs' fields
                    // Extract sign bits
                    a_sign <= a[31];
                    b_sign <= b[31];

                    // Extract exponent fields (8 bits), extend to 10 bits for processing
                    a_exponent <= {2'b00, a[30:23]};
                    b_exponent <= {2'b00, b[30:23]};

                    // Extract mantissa and add implicit leading one if not zero or denormal
                    // IEEE754 single precision bias = 127
                    // Zero and denormals have exponent = 0

                    // Determine special cases here:
                    a_nan <= (a[30:23] == 8'hFF) && (|a[22:0]);
                    b_nan <= (b[30:23] == 8'hFF) && (|b[22:0]);

                    a_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                    b_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 0);

                    a_zero <= (a[30:0] == 31'b0);
                    b_zero <= (b[30:0] == 31'b0);

                    // Prepare mantissas:
                    // If exponent is zero and mantissa zero -> zero
                    // If exponent zero and mantissa nonzero -> denormal (no implicit leading one)
                    // else normal number (implicit leading one)
                    if ((a[30:23] == 8'b0))
                        a_mantissa <= {1'b0, a[22:0]}; // denormal: no implicit leading 1
                    else
                        a_mantissa <= {1'b1, a[22:0]};

                    if ((b[30:23] == 8'b0))
                        b_mantissa <= {1'b0, b[22:0]};
                    else
                        b_mantissa <= {1'b1, b[22:0]};

                    counter <= 3'd1;
                end

                3'd1: begin
                    // Handle special cases and sign result
                    z_sign <= a_sign ^ b_sign;

                    // Check for NaN: if any input NaN => output NaN
                    if (a_nan || b_nan) begin
                        // NaN: exponent all ones, mantissa != 0
                        // Common quiet NaN is with MSB mantissa bit 1
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0}; // Quiet NaN
                        counter <= 3'd7; // done
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0};
                        counter <= 3'd7;
                    end else if (a_inf || b_inf) begin
                        // Inf * anything else (except zero) = Inf
                        z <= {z_sign, 8'hFF, 23'b0};
                        counter <= 3'd7;
                    end else if (a_zero || b_zero) begin
                        // zero * anything = zero
                        z <= {z_sign, 31'b0};
                        counter <= 3'd7;
                    end else begin
                        // Neither special case, proceed

                        // Adjust exponents for denormals:
                        // Denormal exponent = 0, but actual exponent is 1 - bias (i.e. -126)
                        // For normal numbers exponent field is biased by 127
                        // So unbiased exponent = exponent_field - bias (127)
                        // For denormals exponent_field=0, exponent = -126 and implicit leading bit is 0

                        // Convert to unbiased exponents for calculation
                        // Using 10 bits for exponent to allow negative numbers
                        a_exponent <= (a[30:23] == 8'b0) ? 10'd1 - 10'd127 : {2'b00, a[30:23]} - 10'd127;
                        b_exponent <= (b[30:23] == 8'b0) ? 10'd1 - 10'd127 : {2'b00, b[30:23]} - 10'd127;

                        counter <= 3'd2;
                    end
                end

                3'd2: begin
                    // Multiply mantissas: 24 bits x 24 bits = 48 bits product
                    // Store product and add exponents (subtract bias later)

                    product <= a_mantissa * b_mantissa; // 48 bits product; stored in 50 bits reg

                    // Add exponents: sum of unbiased exponents
                    // Result exponent = a_exp + b_exp

                    z_exponent <= a_exponent + b_exponent;

                    counter <= 3'd3;
                end

                3'd3: begin
                    // Normalize product

                    // product is 48 bits at least; actually 24x24=48 bits.
                    // The product mantissa range:
                    // product[47] is MSB bit
                    // Because we multiply two numbers in [1,2), product can be in [1,4)
                    // If product >= 2, MSB is bit 47 set, so normalization requires shifting right 1 and incrementing exponent

                    product_msb = product[47];

                    if (product_msb) begin
                        // MSB at bit 47: value >= 2, shift right by 1
                        // The final mantissa is bits [46:23], rounding bits are lower bits
                        // Increment exponent by 1
                        z_exponent <= z_exponent + 1;
                        norm_product <= product >> 1;
                    end else begin
                        // MSB at bit 46: value in [1,2)
                        norm_product <= product;
                    end

                    counter <= 3'd4;
                end

                3'd4: begin
                    // Extract mantissa bits and rounding bits (guard, round, sticky)
                    // Mantissa: 23 bits fractional + implicit leading one removed for IEEE754 format

                    // We keep 23 bits mantissa in IEEE754 format
                    // norm_product bits [46:24] => 23 bits mantissa
                    // Guard bit: bit 23
                    // Round bit: bit 22
                    // Sticky: OR of bits [21:0]

                    z_mantissa <= norm_product[46:24];

                    guard_bit <= norm_product[23];
                    round_bit <= norm_product[22];
                    sticky <= |norm_product[21:0];

                    counter <= 3'd5;
                end

                3'd5: begin
                    // Rounding: Round to nearest even

                    // Compute round increment condition
                    // Round if guard=1 and (round=1 or sticky=1 or LSB of mantissa=1)

                    if (guard_bit && (round_bit || sticky || z_mantissa[0])) begin
                        z_mantissa <= z_mantissa + 1;

                        // Check mantissa overflow after rounding
                        if (z_mantissa == 24'hFFFFFF) begin
                            // mantissa overflowed, shift right and increment exponent
                            z_mantissa <= 24'h800000; // bit 23 set (implicit 1)
                            z_exponent <= z_exponent + 1;
                        end
                    end

                    counter <= 3'd6;
                end

                3'd6: begin
                    // Assemble output

                    // Convert unbiased exponent back to biased format
                    // biased exponent = z_exponent + 127

                    if (z_exponent + 127 >= 255) begin
                        // Overflow to infinity
                        z <= {z_sign, 8'hFF, 23'b0};
                    end else if (z_exponent + 127 <= 0) begin
                        // Underflow => denormal or zero
                        // For simplicity output zero on underflow
                        z <= {z_sign, 31'b0};
                    end else begin
                        // Normal number
                        z <= {z_sign, (z_exponent + 127)[7:0], z_mantissa[22:0]};
                    end

                    counter <= 3'd7;
                end

                3'd7: begin
                    // Hold output until reset or next operation (could add start signal if needed)
                    // Just remain in done state
                    counter <= 3'd7;
                end

                default: counter <= 3'd0;

            endcase
        end
    end

endmodule