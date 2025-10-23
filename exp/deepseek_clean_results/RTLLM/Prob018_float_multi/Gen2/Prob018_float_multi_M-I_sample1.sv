module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [2:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [9:0] a_exponent, b_exponent, z_exponent; // Extra bit for underflow
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;  // Full 24x24 product
    reg guard_bit, round_bit, sticky;
    reg a_special, b_special;
    reg a_is_zero, b_is_zero, a_is_inf, b_is_inf, a_is_nan, b_is_nan;
    reg mult_en;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            z <= 0;
            mult_en <= 1;
        end else begin
            case (state)
                0: begin // Stage 1: Input processing and special case detection
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= {1'b0, a[30:23]};
                    b_exponent <= {1'b0, b[30:23]};
                    
                    // Handle denormals (exponent=0)
                    a_mantissa <= (a[30:23] == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Detect special cases
                    a_is_zero <= (a[30:0] == 0);
                    b_is_zero <= (b[30:0] == 0);
                    a_is_inf <= (&a[30:23]) && (a[22:0] == 0);
                    b_is_inf <= (&b[30:23]) && (b[22:0] == 0);
                    a_is_nan <= (&a[30:23]) && (|a[22:0]);
                    b_is_nan <= (&b[30:23]) && (|b[22:0]);
                    a_special <= a_is_zero | a_is_inf | a_is_nan;
                    b_special <= b_is_zero | b_is_inf | b_is_nan;

                    // Calculate sign early
                    z_sign <= a_sign ^ b_sign;

                    // Early termination for special cases
                    if (a_is_nan || b_is_nan) begin
                        z <= {z_sign, 8'hFF, 23'h400000}; // Quiet NaN
                        state <= 0;
                        mult_en <= 0;
                    end else if ((a_is_zero && b_is_inf) || (a_is_inf && b_is_zero)) begin
                        z <= {z_sign, 8'hFF, 23'h400000}; // NaN
                        state <= 0;
                        mult_en <= 0;
                    end else if (a_is_inf || b_is_inf) begin
                        z <= {z_sign, 8'hFF, 23'h000000}; // Infinity
                        state <= 0;
                        mult_en <= 0;
                    end else if (a_is_zero || b_is_zero) begin
                        z <= {z_sign, 31'h00000000}; // Zero
                        state <= 0;
                        mult_en <= 0;
                    end else begin
                        state <= 1;
                        mult_en <= 1;
                    end
                end

                1: begin // Stage 2: Multiplication (partial products)
                    if (mult_en) begin
                        // Multiply mantissas (24x24 bits)
                        product <= a_mantissa * b_mantissa;

                        // Calculate exponent sum with proper bias adjustment
                        // Bias = 127, but subtract 1 more if both are denormal
                        z_exponent <= a_exponent + b_exponent - 
                                     ((a_exponent == 0) & (b_exponent == 0)) - 126;

                        state <= 2;
                    end
                end

                2: begin // Stage 3: Normalization
                    if (mult_en) begin
                        // Normalize product (MSB should be at bit 47)
                        if (product[47]) begin
                            product <= product >> 1;
                            z_exponent <= z_exponent + 1;
                        end

                        // Extract rounding bits
                        guard_bit <= product[22];
                        round_bit <= product[21];
                        sticky <= |product[20:0];

                        state <= 3;
                    end
                end

                3: begin // Stage 4: Rounding and output
                    if (mult_en) begin
                        // Extract mantissa
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

                        // Check for exponent overflow/underflow
                        if (z_exponent[9] || (z_exponent[7:0] >= 255)) begin // Overflow
                            z <= {z_sign, 8'hFF, 23'h000000}; // Infinity
                        end else if (z_exponent[7:0] == 0) begin // Underflow
                            z <= {z_sign, 31'h00000000}; // Zero
                        end else begin
                            z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                        end
                    end
                    state <= 0;
                    mult_en <= 1;
                end
            endcase
        end
    end

endmodule