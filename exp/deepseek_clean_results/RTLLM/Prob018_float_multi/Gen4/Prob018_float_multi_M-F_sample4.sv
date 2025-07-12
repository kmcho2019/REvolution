module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [2:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [9:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    reg guard_bit, round_bit, sticky;
    reg a_is_zero, b_is_zero, a_is_inf, b_is_inf, a_is_nan, b_is_nan;
    reg mult_en;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 0;
            z <= 0;
            mult_en <= 1;
        end else begin
            case (state)
                0: begin // Stage 1: Input processing
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= {1'b0, a[30:23]};
                    b_exponent <= {1'b0, b[30:23]};
                    
                    // Handle denormals
                    a_mantissa <= (a[30:23] == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Detect special cases
                    a_is_zero <= (a[30:0] == 0);
                    b_is_zero <= (b[30:0] == 0);
                    a_is_inf <= (&a[30:23]) && (a[22:0] == 0);
                    b_is_inf <= (&b[30:23]) && (b[22:0] == 0);
                    a_is_nan <= (&a[30:23]) && (|a[22:0]);
                    b_is_nan <= (&b[30:23]) && (|b[22:0]);

                    // Calculate sign early
                    z_sign <= a_sign ^ b_sign;

                    // Early termination for special cases
                    if (a_is_nan || b_is_nan) begin
                        z <= {z_sign, 8'hFF, 23'h400000}; // Quiet NaN
                        state <= 0;
                    end else if ((a_is_zero && b_is_inf) || (a_is_inf && b_is_zero)) begin
                        z <= {z_sign, 8'hFF, 23'h400000}; // NaN
                        state <= 0;
                    end else if (a_is_inf || b_is_inf) begin
                        z <= {z_sign, 8'hFF, 23'h000000}; // Infinity
                        state <= 0;
                    end else if (a_is_zero || b_is_zero) begin
                        z <= {z_sign, 31'h00000000}; // Zero
                        state <= 0;
                    end else begin
                        state <= 1;
                        mult_en <= 1;
                    end
                end

                1: begin // Stage 2: Multiplication
                    if (mult_en) begin
                        product <= a_mantissa * b_mantissa;
                        
                        // Correct exponent calculation with proper bias adjustment
                        // For normalized numbers: exp = exp_a + exp_b - 127
                        // For denormals: subtract 1 from exponent for each denormal input
                        z_exponent <= (a_exponent == 0 ? (b_exponent == 0 ? 10'd0 : (b_exponent - 10'd126)) :
                                      (b_exponent == 0 ? (a_exponent - 10'd126) : (a_exponent + b_exponent - 10'd127)));

                        state <= 2;
                    end
                end

                2: begin // Stage 3: Normalization
                    if (mult_en) begin
                        // Normalize product
                        if (product[47]) begin
                            product <= product >> 1;
                            z_exponent <= z_exponent + 1;
                        end

                        // Check for exponent overflow before rounding
                        if (z_exponent[9] || (z_exponent[7:0] >= 255)) begin
                            z <= {z_sign, 8'hFF, 23'h000000}; // Infinity
                            state <= 0;
                        end else if (z_exponent[7:0] == 0) begin // Underflow
                            z <= {z_sign, 31'h00000000}; // Zero
                            state <= 0;
                        end else begin
                            // Extract rounding bits
                            guard_bit <= product[22];
                            round_bit <= product[21];
                            sticky <= |product[20:0];
                            z_mantissa <= product[46:23];
                            state <= 3;
                        end
                    end
                end

                3: begin // Stage 4: Rounding
                    if (mult_en) begin
                        // Round to nearest even
                        if (guard_bit && (round_bit | sticky | z_mantissa[0])) begin
                            z_mantissa <= z_mantissa + 1;
                            // Handle mantissa overflow
                            if (z_mantissa == 24'hFFFFFF) begin
                                z_mantissa <= 24'h800000;
                                z_exponent <= z_exponent + 1;
                            end
                        end

                        // Final overflow check
                        if (z_exponent[9] || (z_exponent[7:0] >= 255)) begin
                            z <= {z_sign, 8'hFF, 23'h000000}; // Infinity
                        end else if (z_exponent[7:0] == 0) begin // Underflow
                            z <= {z_sign, 31'h00000000}; // Zero
                        end else begin
                            z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
                        end
                        state <= 0;
                    end
                end
            endcase
        end
    end

endmodule