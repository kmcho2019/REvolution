module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [1:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    reg guard_bit, round_bit, sticky;
    reg a_is_zero, b_is_zero, a_is_inf, b_is_inf, a_is_nan, b_is_nan;

    // Special case detection signals
    wire a_is_denormal = (a[30:23] == 0);
    wire b_is_denormal = (b[30:23] == 0);
    wire either_nan = a_is_nan || b_is_nan;
    wire either_inf = a_is_inf || b_is_inf;
    wire either_zero = a_is_zero || b_is_zero;
    wire inf_times_zero = (a_is_zero && b_is_inf) || (a_is_inf && b_is_zero);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            z <= 0;
        end else begin
            case (state)
                0: begin // Stage 1: Input processing and special cases
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    
                    // Handle mantissas with hidden bit
                    a_mantissa <= a_is_denormal ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= b_is_denormal ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Detect special cases
                    a_is_zero <= (a[30:0] == 0);
                    b_is_zero <= (b[30:0] == 0);
                    a_is_inf <= (&a_exponent) && (a[22:0] == 0);
                    b_is_inf <= (&b_exponent) && (b[22:0] == 0);
                    a_is_nan <= (&a_exponent) && (|a[22:0]);
                    b_is_nan <= (&b_exponent) && (|b[22:0]);

                    // Calculate sign early
                    z_sign <= a_sign ^ b_sign;

                    // Early termination for special cases
                    if (either_nan) begin
                        z <= {z_sign, 8'hFF, 23'h400000}; // Quiet NaN
                    end else if (inf_times_zero) begin
                        z <= {z_sign, 8'hFF, 23'h400000}; // NaN
                    end else if (either_inf) begin
                        z <= {z_sign, 8'hFF, 23'h000000}; // Infinity
                    end else if (either_zero) begin
                        z <= {z_sign, 31'h00000000}; // Zero
                    end else begin
                        state <= 1;
                    end
                end

                1: begin // Stage 2: Multiplication and exponent calculation
                    // Perform multiplication
                    product <= a_mantissa * b_mantissa;

                    // Calculate exponent with proper bias adjustment
                    // exp = (a_exp - bias + a_denorm) + (b_exp - bias + b_denorm) + bias
                    // Simplified to: a_exp + b_exp - bias + a_denorm + b_denorm
                    z_exponent <= a_exponent + b_exponent - 8'd127 + 
                                 (a_is_denormal ? 8'd0 : 8'd1) + 
                                 (b_is_denormal ? 8'd0 : 8'd1);

                    state <= 2;
                end

                2: begin // Stage 3: Normalization and rounding
                    // Normalize product
                    if (product[47]) begin
                        product <= product >> 1;
                        z_exponent <= z_exponent + 1;
                    end

                    // Extract rounding bits
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky <= |product[20:0];
                    z_mantissa <= product[46:23];

                    // Round to nearest even
                    if (guard_bit && (round_bit | sticky | z_mantissa[0])) begin
                        z_mantissa <= z_mantissa + 1;
                        // Handle mantissa overflow
                        if (&z_mantissa) begin
                            z_mantissa <= 24'h800000;
                            z_exponent <= z_exponent + 1;
                        end
                    end

                    // Final overflow/underflow check
                    if (z_exponent[7] || (&z_exponent[6:0])) begin // >= 255
                        z <= {z_sign, 8'hFF, 23'h000000}; // Infinity
                    end else if (z_exponent == 0) begin // Underflow
                        z <= {z_sign, 31'h00000000}; // Zero
                    end else begin
                        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                    end

                    state <= 0;
                end
            endcase
        end
    end

endmodule