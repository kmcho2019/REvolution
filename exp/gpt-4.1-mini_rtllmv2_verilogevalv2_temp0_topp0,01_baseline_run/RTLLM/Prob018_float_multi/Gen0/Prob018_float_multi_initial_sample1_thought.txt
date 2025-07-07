```thought
Implement a pipelined 3-cycle IEEE-754 single-precision floating-point multiplier. On reset, clear the counter. On the first cycle, extract sign, exponent, and mantissa from inputs, handle special cases (zero, infinity, NaN). On the second cycle, multiply mantissas (including implicit leading 1 for normalized numbers), add exponents (subtract bias), and determine sign. On the third cycle, normalize the product, apply rounding using guard, round, and sticky bits, adjust exponent for overflow/underflow, and assemble the final IEEE-754 result. Output the result and hold it until reset or new operation.
```
```code
module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;

    // Decomposed inputs
    reg a_sign, b_sign;
    reg [7:0] a_exponent, b_exponent;
    reg [23:0] a_mantissa, b_mantissa; // 24 bits including implicit leading 1 if normalized

    // Intermediate signals
    reg z_sign;
    reg [9:0] z_exponent; // wider to hold exponent sum and adjustments
    reg [49:0] product;   // 24x24 multiplication result (max 48 bits), use 50 bits for rounding bits
    reg [23:0] z_mantissa;

    // Rounding bits
    reg guard_bit, round_bit, sticky;

    // Special cases flags
    reg a_is_zero, b_is_zero;
    reg a_is_inf, b_is_inf;
    reg a_is_nan, b_is_nan;

    // Internal normalized product mantissa and exponent after normalization
    reg [23:0] norm_mantissa;
    reg [9:0] norm_exponent;

    // Sticky bit calculation helper
    wire [24:0] product_low_bits;

    // Bias for IEEE-754 single precision
    localparam BIAS = 127;

    // Extract fields and detect special cases
    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            z <= 32'b0;
            a_sign <= 0; b_sign <= 0;
            a_exponent <= 0; b_exponent <= 0;
            a_mantissa <= 0; b_mantissa <= 0;
            z_sign <= 0;
            z_exponent <= 0;
            z_mantissa <= 0;
            product <= 0;
            guard_bit <= 0; round_bit <= 0; sticky <= 0;
            a_is_zero <= 0; b_is_zero <= 0;
            a_is_inf <= 0; b_is_inf <= 0;
            a_is_nan <= 0; b_is_nan <= 0;
            norm_mantissa <= 0;
            norm_exponent <= 0;
        end else begin
            case (counter)
                3'd0: begin
                    // Extract sign
                    a_sign <= a[31];
                    b_sign <= b[31];

                    // Extract exponent
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];

                    // Extract mantissa and add implicit leading 1 if normalized
                    // If exponent == 0, denormalized number, no implicit leading 1
                    a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Detect special cases for a
                    a_is_zero <= (a[30:0] == 31'b0);
                    a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                    a_is_nan <= (a[30:23] == 8'hFF) && (a[22:0] != 0);

                    // Detect special cases for b
                    b_is_zero <= (b[30:0] == 31'b0);
                    b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 0);
                    b_is_nan <= (b[30:23] == 8'hFF) && (b[22:0] != 0);

                    counter <= 3'd1;
                end

                3'd1: begin
                    // Handle special cases first
                    // If either input is NaN, output NaN
                    if (a_is_nan || b_is_nan) begin
                        // Quiet NaN: exponent all ones, mantissa non-zero MSB=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0};
                        counter <= 3'd0;
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'b0};
                        counter <= 3'd0;
                    end else if (a_is_inf || b_is_inf) begin
                        // Inf * non-zero = Inf with sign
                        z_sign <= a_sign ^ b_sign;
                        z_exponent <= 10'h1FF; // all ones exponent (255)
                        z_mantissa <= 0;
                        z <= {z_sign, 8'hFF, 23'b0};
                        counter <= 3'd0;
                    end else if (a_is_zero || b_is_zero) begin
                        // zero * anything = zero with sign
                        z_sign <= a_sign ^ b_sign;
                        z_exponent <= 0;
                        z_mantissa <= 0;
                        z <= {z_sign, 31'b0};
                        counter <= 3'd0;
                    end else begin
                        // Normal multiplication path
                        // Multiply mantissas: 24 bits * 24 bits = 48 bits product
                        product <= a_mantissa * b_mantissa; // 48 bits product

                        // Add exponents and subtract bias
                        // Use 10 bits to hold sum and adjustments
                        z_exponent <= a_exponent + b_exponent - BIAS;

                        // Calculate sign
                        z_sign <= a_sign ^ b_sign;

                        counter <= 3'd2;
                    end
                end

                3'd2: begin
                    // Normalize product and prepare rounding bits
                    // product is 48 bits, but stored in 50 bits reg for rounding bits
                    // product[47:0] valid, product[49:48] unused

                    // The product is 48 bits, but we have 50 bits reg, so zero upper bits
                    // Actually product is 48 bits, but we declared 50 bits reg, so upper bits zero
                    // We'll consider product[47:0]

                    // Normalization:
                    // The product mantissa is 48 bits, representing 2*24 bits
                    // The leading bit can be at bit 47 or 46:
                    // If product[47] == 1, the product is already normalized (leading 1 at bit 47)
                    // Else shift left by 1 and decrement exponent

                    if (product[47] == 1'b1) begin
                        // Leading one at bit 47, take bits [46:24] as mantissa (23 bits)
                        // We'll take bits [46:24] as mantissa, and bits [23:0] for rounding bits
                        norm_mantissa <= product[46:24];
                        norm_exponent <= z_exponent + 1; // Because product is effectively shifted left by 1
                        // Rounding bits:
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky <= |product[21:0];
                    end else begin
                        // Leading one at bit 46, shift left by 1
                        norm_mantissa <= product[45:23];
                        norm_exponent <= z_exponent;
                        // Rounding bits:
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky <= |product[20:0];
                    end

                    counter <= 3'd3;
                end

                3'd3: begin
                    // Rounding: round to nearest even
                    // If guard bit = 1 and (round bit or sticky bit or LSB of mantissa = 1), round up
                    if (guard_bit && (round_bit || sticky || norm_mantissa[0])) begin
                        {norm_exponent, norm_mantissa} <= {norm_exponent, norm_mantissa} + 1'b1;
                    end

                    // Handle mantissa overflow after rounding (carry out)
                    if (norm_mantissa == 24'h1000000) begin
                        // Mantissa overflowed (24 bits), shift right and increment exponent
                        norm_mantissa <= norm_mantissa >> 1;
                        norm_exponent <= norm_exponent + 1;
                    end

                    // Handle exponent overflow and underflow
                    if (norm_exponent >= 10'd255) begin
                        // Overflow: output infinity
                        z <= {z_sign

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
