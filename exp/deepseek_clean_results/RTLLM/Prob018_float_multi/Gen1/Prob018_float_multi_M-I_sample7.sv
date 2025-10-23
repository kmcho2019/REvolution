module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [1:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [8:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [46:0] product;  // Reduced from 48 to 47 bits
    reg guard_bit, round_bit, sticky;
    reg a_is_zero, a_is_denorm, a_is_inf, a_is_nan;
    reg b_is_zero, b_is_denorm, b_is_inf, b_is_nan;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            z <= 0;
        end else begin
            case (state)
                0: begin // Stage 1: Input processing
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    
                    // Handle denormals (exponent=0)
                    a_is_denorm <= (a[30:23] == 0);
                    b_is_denorm <= (b[30:23] == 0);
                    a_mantissa <= a_is_denorm ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= b_is_denorm ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Detect special cases
                    a_is_zero <= (a[30:0] == 0);
                    b_is_zero <= (b[30:0] == 0);
                    a_is_inf <= (&a[30:23]) && (a[22:0] == 0);
                    b_is_inf <= (&b[30:23]) && (b[22:0] == 0);
                    a_is_nan <= (&a[30:23]) && (|a[22:0]);
                    b_is_nan <= (&b[30:23]) && (|b[22:0]);

                    // Early termination for special cases
                    if (a_is_nan || b_is_nan) begin
                        z <= 32'h7FC00000; // Canonical NaN
                        state <= 0;
                    end else if ((a_is_zero && b_is_inf) || (a_is_inf && b_is_zero)) begin
                        z <= {a_sign ^ b_sign, 8'hFF, 23'h000001}; // NaN
                        state <= 0;
                    end else if (a_is_inf || b_is_inf) begin
                        z <= {a_sign ^ b_sign, 8'hFF, 23'h000000}; // Infinity
                        state <= 0;
                    end else if (a_is_zero || b_is_zero) begin
                        z <= {a_sign ^ b_sign, 31'h00000000}; // Zero
                        state <= 0;
                    end else begin
                        state <= 1;
                    end
                end

                1: begin // Stage 2: Multiplication
                    // Multiply mantissas (24x24 bits)
                    product <= a_mantissa * b_mantissa[23:1]; // 24x23 multiplication

                    // Calculate exponent sum with bias adjustment
                    // Add 1 to exponent if either input is denormal
                    z_exponent <= a_exponent + b_exponent + a_is_denorm + b_is_denorm - 127;

                    // Calculate sign
                    z_sign <= a_sign ^ b_sign;

                    state <= 2;
                end

                2: begin // Stage 3: Normalization and rounding
                    // Normalize product (MSB is at bit 46 now)
                    if (product[46]) begin
                        product <= product >> 1;
                        z_exponent <= z_exponent + 1;
                    end

                    // Extract mantissa and rounding bits
                    z_mantissa <= product[45:23];
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky <= |product[20:0];

                    // Round to nearest even (simplified expression)
                    if (guard_bit && (round_bit | sticky | z_mantissa[0])) begin
                        z_mantissa <= z_mantissa + 1;
                        // Handle mantissa overflow
                        if (z_mantissa == 24'hFFFFFF) begin
                            z_mantissa <= 24'h800000;
                            z_exponent <= z_exponent + 1;
                        end
                    end

                    // Check for exponent overflow/underflow
                    if (z_exponent[8] || (z_exponent[7:0] >= 255)) begin // Overflow
                        z <= {z_sign, 8'hFF, 23'h000000}; // Infinity
                    end else if (z_exponent[7:0] == 0) begin // Underflow
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