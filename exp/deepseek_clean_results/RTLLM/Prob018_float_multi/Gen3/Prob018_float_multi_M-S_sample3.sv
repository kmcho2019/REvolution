module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [1:0] state;
    reg [23:0] a_mantissa, b_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    reg special_case;

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
                    
                    // Handle denormals (exponent=0)
                    a_mantissa <= (a[30:23] == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_mantissa <= (b[30:23] == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

                    // Calculate sign early
                    z_sign <= a_sign ^ b_sign;

                    // Check for special cases
                    if ((&a_exponent && |a[22:0]) || (&b_exponent && |b[22:0]) begin
                        z <= {z_sign, 8'hFF, 23'h400000}; // NaN
                        special_case <= 1;
                    end else if ((a_exponent == 8'hFF) || (b_exponent == 8'hFF)) begin
                        z <= {z_sign, 8'hFF, 23'h000000}; // Infinity
                        special_case <= 1;
                    end else if ((a[30:0] == 0) || (b[30:0] == 0)) begin
                        z <= {z_sign, 31'h00000000}; // Zero
                        special_case <= 1;
                    end else begin
                        special_case <= 0;
                    end

                    state <= 1;
                end

                1: begin // Stage 2: Multiplication
                    if (!special_case) begin
                        product <= a_mantissa * b_mantissa;
                        z_exponent <= a_exponent + b_exponent - 127; // Standard bias
                        state <= 2;
                    end else begin
                        state <= 0;
                    end
                end

                2: begin // Stage 3: Normalization and rounding
                    // Normalize product
                    if (product[47]) begin
                        product <= product >> 1;
                        z_exponent <= z_exponent + 1;
                    end

                    // Round to nearest even
                    if (product[22] && (product[21] | |product[20:0] | product[23])) begin
                        product[46:23] <= product[46:23] + 1;
                        if (product[46:23] == 24'hFFFFFF) begin // Handle overflow
                            product[46:23] <= 24'h800000;
                            z_exponent <= z_exponent + 1;
                        end
                    end

                    // Check for exponent overflow/underflow
                    if (z_exponent[7] && z_exponent != 8'hFF) begin // Underflow
                        z <= {z_sign, 31'h00000000};
                    end else if (z_exponent == 8'hFF) begin // Overflow
                        z <= {z_sign, 8'hFF, 23'h000000};
                    end else begin
                        z <= {z_sign, z_exponent, product[45:23]};
                    end

                    state <= 0;
                end
            endcase
        end
    end

endmodule