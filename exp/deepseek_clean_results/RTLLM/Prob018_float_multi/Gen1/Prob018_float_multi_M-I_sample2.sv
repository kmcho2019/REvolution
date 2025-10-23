module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [1:0] counter;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    reg a_is_zero, a_is_denorm, a_is_inf, a_is_nan;
    reg b_is_zero, b_is_denorm, b_is_inf, b_is_nan;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            z <= 0;
        end else begin
            case (counter)
                0: begin // Cycle 1: Input processing
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    
                    // Handle denormal numbers
                    a_is_denorm <= (a_exponent == 0) && (|a[22:0]);
                    b_is_denorm <= (b_exponent == 0) && (|b[22:0]);
                    
                    a_mantissa <= a_is_denorm ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= b_is_denorm ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Detect special cases
                    a_is_zero <= (a[30:0] == 0);
                    b_is_zero <= (b[30:0] == 0);
                    a_is_inf <= (&a_exponent) && (a[22:0] == 0);
                    b_is_inf <= (&b_exponent) && (b[22:0] == 0);
                    a_is_nan <= (&a_exponent) && (|a[22:0]);
                    b_is_nan <= (&b_exponent) && (|b[22:0]);

                    counter <= 1;
                end

                1: begin // Cycle 2: Multiplication
                    // Multiply mantissas (24x24 bits)
                    product <= a_mantissa * b_mantissa;

                    // Calculate exponent sum with bias adjustment
                    // For denormals, exponent is treated as 1 (after normalization)
                    z_exponent <= (a_is_denorm ? 9'd1 : a_exponent) + 
                                 (b_is_denorm ? 9'd1 : b_exponent) - 9'd127;

                    // Calculate sign
                    z_sign <= a_sign ^ b_sign;

                    counter <= 2;
                end

                2: begin // Cycle 3: Normalization and rounding
                    // Handle special cases first (NaN has highest priority)
                    if (a_is_nan || b_is_nan) begin
                        z <= {1'b0, 8'hFF, 1'b1, 22'h0}; // Canonical NaN
                    end else if ((a_is_zero && b_is_inf) || (a_is_inf && b_is_zero)) begin
                        z <= {z_sign, 8'hFF, 1'b1, 22'h0}; // NaN
                    end else if (a_is_inf || b_is_inf) begin
                        z <= {z_sign, 8'hFF, 23'h0}; // Infinity
                    end else if (a_is_zero || b_is_zero) begin
                        z <= {z_sign, 31'h0}; // Zero
                    end else begin
                        // Normalize product (shift left until MSB is 1)
                        if (product[47] == 0) begin
                            product <= product << 1;
                            z_exponent <= z_exponent - 1;
                        end

                        // Extract mantissa and rounding bits
                        z_mantissa <= product[46:24];
                        // Combine guard, round and sticky bits
                        if (|product[23:0]) begin
                            z_mantissa <= z_mantissa + ((product[23] & (product[22] | |product[21:0] | z_mantissa[0])) ? 1 : 0;
                        end

                        // Handle mantissa overflow after rounding
                        if (z_mantissa[23]) begin
                            z_mantissa <= z_mantissa >> 1;
                            z_exponent <= z_exponent + 1;
                        end

                        // Check for exponent overflow/underflow
                        if (z_exponent[8] || (&z_exponent[7:0])) begin // Overflow
                            z <= {z_sign, 8'hFF, 23'h0}; // Infinity
                        end else if (z_exponent[7:0] == 0) begin // Underflow
                            z <= {z_sign, 31'h0}; // Zero
                        end else begin
                            z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                        end
                    end

                    counter <= 0;
                end
            endcase
        end
    end

endmodule