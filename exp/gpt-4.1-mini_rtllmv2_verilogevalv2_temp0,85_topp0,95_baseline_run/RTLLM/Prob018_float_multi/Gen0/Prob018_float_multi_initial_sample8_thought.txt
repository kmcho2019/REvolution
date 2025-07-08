```thought
Design a pipelined, multi-cycle 32-bit IEEE-754 single-precision floating-point multiplier. On reset, initialize the counter. On the first cycle, extract sign, exponent, and mantissa from inputs. Detect special cases (NaN, infinity, zero). If normal numbers, add exponents with bias correction, multiply mantissas with implicit leading one, and determine sign. Normalize the product, extract guard, round, and sticky bits for rounding (round to nearest even). Adjust exponent after normalization and rounding. Handle overflow/underflow by saturating to infinity or zero. Output the final IEEE-754 result after a fixed number of cycles (3 cycles total to allow multiplication and normalization). The module is synchronous with clock and reset.
```
```code
module float_multi (
    input            clk,
    input            rst,
    input  [31:0]    a,
    input  [31:0]    b,
    output reg [31:0] z
);

    // Cycle counter
    reg [2:0] counter;

    // Extracted fields
    reg          a_sign, b_sign, z_sign;
    reg [9:0]    a_exponent, b_exponent, z_exponent; // wider to hold intermediate sums
    reg [23:0]   a_mantissa, b_mantissa, z_mantissa; // include implicit leading 1 if normalized

    // Intermediate product (24x24 -> 48 bits), keep extra bits for rounding (50 bits total)
    reg [49:0] product;

    // Rounding bits
    reg guard_bit, round_bit, sticky;

    // Special flags
    reg a_is_nan, b_is_nan;
    reg a_is_inf, b_is_inf;
    reg a_is_zero, b_is_zero;

    // Temporary signals for normalization and rounding
    reg [49:0] product_norm;
    reg [9:0]  exponent_norm;

    // States for pipeline stages
    // 0: idle/start, 1: extract & check special, 2: multiply mantissa, 3: normalize, round, output
    // counter increments every clock cycle if not reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'd0;
            z <= 32'd0;
            // reset other registers
            a_sign <= 0; b_sign <= 0; z_sign <= 0;
            a_exponent <= 0; b_exponent <= 0; z_exponent <= 0;
            a_mantissa <= 0; b_mantissa <= 0; z_mantissa <= 0;
            product <= 0;
            guard_bit <= 0; round_bit <= 0; sticky <= 0;
            a_is_nan <= 0; b_is_nan <= 0;
            a_is_inf <= 0; b_is_inf <= 0;
            a_is_zero <= 0; b_is_zero <= 0;
        end else begin
            if(counter == 3'd0) begin
                // Start extraction of inputs
                counter <= 3'd1;

                // Extract sign bits
                a_sign <= a[31];
                b_sign <= b[31];

                // Extract exponents as 10-bit values for intermediate calc (to avoid overflow)
                a_exponent <= {2'b00, a[30:23]};
                b_exponent <= {2'b00, b[30:23]};

                // Extract mantissas and add implicit leading one if normalized
                // If exponent!=0, mantissa = 1.xxx else subnormal: leading zero
                a_mantissa <= (a[30:23] == 8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                b_mantissa <= (b[30:23] == 8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                // Detect special cases for a
                a_is_nan  <= (a[30:23] == 8'hFF) && (|a[22:0]);
                a_is_inf  <= (a[30:23] == 8'hFF) && (~|a[22:0]);
                a_is_zero <= (a[30:23] == 8) && (~|a[22:0]); // exponent zero and mantissa zero means zero

                // Detect special cases for b
                b_is_nan  <= (b[30:23] == 8'hFF) && (|b[22:0]);
                b_is_inf  <= (b[30:23] == 8'hFF) && (~|b[22:0]);
                b_is_zero <= (b[30:23] == 8) && (~|b[22:0]);

                // Clear output for now
                z <= 32'd0;
            end else if(counter == 3'd1) begin
                // Handle special cases and prepare for multiplication

                // Determine sign of result
                z_sign <= a_sign ^ b_sign;

                // Check for NaN propagation
                if (a_is_nan) begin
                    // propagate a NaN
                    z <= {1'b0,8'hFF,1'b1,22'd0}; // quiet NaN pattern (MSB of mantissa set)
                    counter <= 3'd0;
                end else if (b_is_nan) begin
                    z <= {1'b0,8'hFF,1'b1,22'd0};
                    counter <= 3'd0;
                end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                    // Inf * 0 = NaN
                    z <=

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
