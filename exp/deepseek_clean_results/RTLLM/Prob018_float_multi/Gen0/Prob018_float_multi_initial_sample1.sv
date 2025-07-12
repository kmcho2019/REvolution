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
    reg a_is_zero, b_is_zero, a_is_inf, b_is_inf, a_is_nan, b_is_nan;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 0;
        end else begin
            case (counter)
                0: begin // Cycle 1: Input processing and special cases
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};

                    // Check special cases
                    a_is_zero <= (a[30:0] == 0);
                    b_is_zero <= (b[30:0] == 0);
                    a_is_inf <= (&a[30:23]) && (a[22:0] == 0);
                    b_is_inf <= (&b[30:23]) && (b[22:0] == 0);
                    a_is_nan <= (&a[30:23]) && (|a[22:0]);
                    b_is_nan <= (&b[30:23]) && (|b[22:0]);

                    counter <= 1;
                end

                1: begin // Cycle 2: Multiplication and exponent calculation
                    // Handle special cases
                    if (a_is_nan || b_is_nan) begin
                        z <= 32'h7FC00000; // NaN
                        counter <= 0;
                    end else if ((a_is_zero && b_is_inf) || (a_is_inf && b_is_zero)) begin
                        z <= 32'h7FC00000; // 0 * inf = NaN
                        counter <= 0;
                    end else if (a_is_zero || b_is_zero) begin
                        z <= {a_sign ^ b_sign, 31'b0}; // Signed zero
                        counter <= 0;
                    end else if (a_is_inf || b_is_inf) begin
                        z <= {a_sign ^ b_sign, 8'hFF, 23'b0}; // Infinity
                        counter <= 0;
                    end else begin
                        // Multiply mantissas (24x24 bits)
                        product <= a_mantissa * b_mantissa;

                        // Calculate exponent (subtract bias 127)
                        z_exponent <= a_exponent + b_exponent - 10'd127;

                        counter <= 2;
                    end
                end

                2: begin // Cycle 3: Normalization and rounding
                    // Normalize product
                    if (product[47]) begin
                        z_mantissa <= product[47:24];
                        guard_bit <= product[23];
                        round_bit <= product[22];
                        sticky <= |product[21:0];
                        z_exponent <= z_exponent + 1;
                    end else begin
                        z_mantissa <= product[46:23];
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky <= |product[20:0];
                    end

                    counter <= 3;
                end

                3: begin // Cycle 4: Final rounding and output
                    // Round to nearest even
                    if (guard_bit && (round_bit || sticky || z_mantissa[0])) begin
                        z_mantissa <= z_mantissa + 1;
                        if (&z_mantissa) begin // Overflow in mantissa
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end

                    // Check for exponent overflow/underflow
                    if (z_exponent[9] || (z_exponent >= 10'h0FF)) begin // Overflow
                        z <= {a_sign ^ b_sign, 8'hFF, 23'b0}; // Infinity
                    end else if (z_exponent == 0) begin // Underflow
                        z <= {a_sign ^ b_sign, 31'b0}; // Zero
                    end else begin
                        z <= {a_sign ^ b_sign, z_exponent[7:0], z_mantissa[22:0]};
                    end

                    counter <= 0;
                end
            endcase
        end
    end

endmodule