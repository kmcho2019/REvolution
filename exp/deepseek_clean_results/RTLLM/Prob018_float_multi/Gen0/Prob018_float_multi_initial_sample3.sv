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
    reg [7:0] exponent_sum;
    reg [47:0] product_shifted;
    reg [22:0] mantissa_rounded;
    reg exponent_overflow, exponent_underflow;

    // Special case flags
    reg a_is_zero, a_is_inf, a_is_nan;
    reg b_is_zero, b_is_inf, b_is_nan;
    reg z_is_zero, z_is_inf, z_is_nan;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 32'h0;
        end else begin
            case (counter)
                0: begin // Cycle 1: Input processing
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= {2'b0, a[30:23]};
                    b_exponent <= {2'b0, b[30:23]};
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};

                    // Detect special cases
                    a_is_zero <= (a[30:0] == 0);
                    b_is_zero <= (b[30:0] == 0);
                    a_is_inf <= (&a[30:23]) && (a[22:0] == 0);
                    b_is_inf <= (&b[30:23]) && (b[22:0] == 0);
                    a_is_nan <= (&a[30:23]) && (|a[22:0]);
                    b_is_nan <= (&b[30:23]) && (|b[22:0]);

                    counter <= 1;
                end

                1: begin // Cycle 2: Multiplication
                    // Multiply mantissas (24x24 bits)
                    product <= a_mantissa * b_mantissa;

                    // Calculate exponent sum (subtract bias)
                    exponent_sum <= a_exponent + b_exponent - 10'd127;

                    // Calculate sign
                    z_sign <= a_sign ^ b_sign;

                    counter <= 2;
                end

                2: begin // Cycle 3: Normalization and rounding
                    // Handle special cases first
                    if (a_is_nan || b_is_nan) begin
                        z_is_nan <= 1;
                    end else if ((a_is_zero && b_is_inf) || (a_is_inf && b_is_zero)) begin
                        z_is_nan <= 1;
                    end else if (a_is_inf || b_is_inf) begin
                        z_is_inf <= 1;
                    end else if (a_is_zero || b_is_zero) begin
                        z_is_zero <= 1;
                    end else begin
                        // Normalize product
                        if (product[47]) begin
                            product_shifted <= product;
                            z_exponent <= exponent_sum + 1;
                        end else begin
                            product_shifted <= product << 1;
                            z_exponent <= exponent_sum;
                        end

                        // Extract rounding bits
                        guard_bit <= product_shifted[22];
                        round_bit <= product_shifted[21];
                        sticky <= |product_shifted[20:0];

                        // Round to nearest even
                        if (guard_bit && (round_bit || sticky || product_shifted[23])) begin
                            mantissa_rounded <= product_shifted[46:24] + 1;
                            if (&product_shifted[46:24]) begin // Check for mantissa overflow
                                z_exponent <= z_exponent + 1;
                            end
                        end else begin
                            mantissa_rounded <= product_shifted[46:24];
                        end

                        // Check for exponent overflow/underflow
                        exponent_overflow <= (z_exponent >= 10'd255);
                        exponent_underflow <= (z_exponent[9] || (z_exponent == 0));
                    end

                    counter <= 3;
                end

                3: begin // Final output
                    if (z_is_nan) begin
                        z <= {1'b0, 8'hFF, 23'h7FFFFF}; // Quiet NaN
                    end else if (z_is_inf) begin
                        z <= {z_sign, 8'hFF, 23'h0};
                    end else if (z_is_zero) begin
                        z <= {z_sign, 31'h0};
                    end else if (exponent_overflow) begin
                        z <= {z_sign, 8'hFF, 23'h0}; // Infinity
                    end else if (exponent_underflow) begin
                        z <= {z_sign, 31'h0}; // Zero
                    end else begin
                        z <= {z_sign, z_exponent[7:0], mantissa_rounded[22:0]};
                    end

                    // Reset flags for next operation
                    counter <= 0;
                    z_is_zero <= 0;
                    z_is_inf <= 0;
                    z_is_nan <= 0;
                end
            endcase
        end
    end

endmodule