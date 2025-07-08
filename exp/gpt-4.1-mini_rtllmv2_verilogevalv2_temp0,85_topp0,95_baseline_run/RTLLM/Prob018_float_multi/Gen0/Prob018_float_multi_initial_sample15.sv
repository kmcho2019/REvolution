```thought
Implement a pipelined IEEE-754 single-precision floating-point multiplier with a 3-cycle operation controlled by a 3-bit counter. Extract sign, exponent, and mantissa from inputs. Handle special cases (NaN, infinities, zeros) first. Perform mantissa multiplication with implicit leading 1 for normalized numbers. Adjust exponent by adding exponents and subtracting bias (127). Normalize the product, apply rounding (round to nearest, ties to even) using guard, round, sticky bits. Handle overflow and underflow in exponent. Combine sign, exponent, mantissa into final IEEE-754 result. The pipeline advances on clk, resets on rst.
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
    reg [9:0] a_exponent, b_exponent; // extended to 10 bits for exponent arithmetic
    reg [23:0] a_mantissa, b_mantissa;

    // Intermediate signals
    reg z_sign;
    reg [9:0] z_exponent;
    reg [49:0] product;

    reg guard_bit, round_bit, sticky;

    // Special flags
    reg a_is_nan, b_is_nan;
    reg a_is_inf, b_is_inf;
    reg a_is_zero, b_is_zero;

    // Normalized mantissa after multiplication before rounding
    reg [23:0] z_mantissa;

    // Temporary variables for rounding and normalization
    reg [49:0] mantissa_product;
    reg [9:0] exponent_sum;

    // Rounding helpers
    reg [24:0] rounded_mantissa; // 24 bits +1 for rounding carry out

    // Pipeline registers for special handling
    reg special_case; 
    reg [31:0] special_result;

    // Extract fields at cycle 1
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 3'b000;
            z <= 32'b0;
            a_sign <= 0;
            b_sign <= 0;
            a_exponent <= 0;
            b_exponent <= 0;
            a_mantissa <= 0;
            b_mantissa <= 0;
            product <= 0;
            z_sign <= 0;
            z_exponent <= 0;
            z_mantissa <= 0;
            guard_bit <= 0;
            round_bit <= 0;
            sticky <= 0;
            special_case <= 0;
            special_result <= 0;
        end else begin
            counter <= counter + 1;

            case(counter)
                3'd0: begin
                    // Idle or initial state, no operation
                    z <= 32'b0;
                    special_case <= 0;
                end

                3'd1: begin
                    // Extract sign, exponent, mantissa
                    a_sign <= a[31];
                    b_sign <= b[31];

                    // exponent extended to 10 bits to handle addition and bias adjustment
                    a_exponent <= {2'b00, a[30:23]};
                    b_exponent <= {2'b00, b[30:23]};

                    // Mantissa with implicit leading 1 if exponent not zero (normalized), else no leading 1 (denormalized)
                    a_mantissa <= (a[30:23] == 8'b0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 8'b0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Detect special cases: NaN, Inf, zero
                    a_is_nan <= (a[30:23] == 8'hFF) && (|a[22:0]);
                    b_is_nan <= (b[30:23] == 8'hFF) && (|b[22:0]);

                    a_is_inf <= (a[30:23] == 8'hFF) && (a[22:0] == 0);
                    b_is_inf <= (b[30:23] == 8'hFF) && (b[22:0] == 0);

                    a_is_zero <= (a[30:23] == 8'b0) && (a[22:0] == 0);
                    b_is_zero <= (b[30:23] == 8'b0) && (b[22:0] == 0);

                    special_case <= 0;
                    special_result <= 0;

                    // Compute sign of product
                    z_sign <= a[31] ^ b[31];

                end

                3'd2: begin
                    // Handle special cases first
                    if (a_is_nan || b_is_nan) begin
                        // If either is NaN, output NaN (quiet NaN: exp=FF, mantissa MSB=1)
                        special_case <= 1;
                        special_result <= {1'b0, 8'hFF, 1'b1, 22'b0}; // quiet NaN
                        // preserve sign 0 for NaN
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        // Inf * 0 = NaN
                        special_case <= 1;
                        special_result <= {1'b0, 8'hFF, 1'b1, 22'b0}; // quiet NaN
                    end else if (a_is_inf || b_is_inf) begin

--- WARNING: Parsing Issues ---
Could not parse 'code' from LLM response. Expected ```code ... ``` block.(PARSE_ERROR)
