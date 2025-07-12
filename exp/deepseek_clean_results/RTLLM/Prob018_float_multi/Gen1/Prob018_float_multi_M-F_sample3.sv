module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [2:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [9:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    reg guard_bit, round_bit, sticky;
    reg [9:0] exponent_sum;
    reg [47:0] product_normalized;

    // Special case flags
    reg a_is_zero, b_is_zero;
    reg a_is_inf, b_is_inf;
    reg a_is_nan, b_is_nan;
    reg a_is_denorm, b_is_denorm;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 32'h0;
        end else begin
            case (counter)
                0: begin // Cycle 1: Input processing and special case detection
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= {2'b0, a[30:23]};
                    b_exponent <= {2'b0, b[30:23]};
                    a_is_denorm <= (a[30:23] == 8'b0);
                    b_is_denorm <= (b[30:23] == 8'b0);
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};

                    // Detect special cases
                    a_is_zero <= (a[30:0] == 31'b0);
                    b_is_zero <= (b[30:0] == 31'b0);
                    a_is_inf <= (&a[30:23]) && (a[22:0] == 23'b0);
                    b_is_inf <= (&b[30:23]) && (b[22:0] == 23'b0);
                    a_is_nan <= (&a[30:23]) && (|a[22:0]);
                    b_is_nan <= (&b[30:23]) && (|b[22:0]);

                    counter <= 1;
                end

                1: begin // Cycle 2: Handle special cases and prepare multiplication
                    // Handle NaN cases (NaN takes precedence)
                    if (a_is_nan || b_is_nan) begin
                        z <= {1'b0, 8'hFF, 23'h7FFFFF}; // Canonical NaN
                        counter <= 0;
                    end
                    // Infinity * zero = NaN
                    else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        z <= {1'b0, 8'hFF, 23'h7FFFFF}; // Canonical NaN
                        counter <= 0;
                    end
                    // Infinity * non-zero = Infinity
                    else if (a_is_inf || b_is_inf) begin
                        z <= {(a_sign ^ b_sign), 8'hFF, 23'h0};
                        counter <= 0;
                    end
                    // Zero * anything = Zero
                    else if (a_is_zero || b_is_zero) begin
                        z <= {(a_sign ^ b_sign), 31'h0};
                        counter <= 0;
                    end
                    else begin
                        // Calculate exponent sum (with bias adjustment)
                        exponent_sum <= a_exponent + b_exponent - 127;
                        // Multiply mantissas
                        product <= a_mantissa * b_mantissa;
                        counter <= 2;
                    end
                end

                2: begin // Cycle 3: Normalization and rounding preparation
                    // Normalize product (shift left until MSB is 1)
                    if (product[47]) begin
                        product_normalized <= product;
                        z_exponent <= exponent_sum + 1;
                    end else if (product[46]) begin
                        product_normalized <= product << 1;
                        z_exponent <= exponent_sum;
                    end else begin
                        // Handle cases where product is smaller than expected
                        product_normalized <= product << 2;
                        z_exponent <= exponent_sum - 1;
                    end

                    // Extract rounding bits
                    guard_bit <= product_normalized[22];
                    round_bit <= product_normalized[21];
                    sticky <= |product_normalized[20:0];

                    counter <= 3;
                end

                3: begin // Cycle 4: Rounding and final assembly
                    // Default mantissa (truncated)
                    z_mantissa <= product_normalized[46:24];

                    // Round up if needed (round to nearest, ties to even)
                    if (guard_bit && (round_bit || sticky || z_mantissa[0])) begin
                        if (z_mantissa != 24'hFFFFFF) begin
                            z_mantissa <= z_mantissa + 1;
                        end else begin
                            // Handle mantissa overflow by incrementing exponent
                            z_mantissa <= 24'h800000;
                            z_exponent <= z_exponent + 1;
                        end
                    end

                    // Check for exponent overflow/underflow
                    if (z_exponent >= 10'h1FE) begin // Overflow (>= 255 after bias)
                        z <= {(a_sign ^ b_sign), 8'hFF, 23'h0}; // Infinity
                    end else if (z_exponent[9] || (z_exponent[7:0] == 0)) begin // Underflow
                        z <= {(a_sign ^ b_sign), 31'h0}; // Zero
                    end else begin // Normal case
                        z <= {(a_sign ^ b_sign), z_exponent[7:0], z_mantissa[22:0]};
                    end

                    counter <= 0;
                end
            endcase
        end
    end

endmodule