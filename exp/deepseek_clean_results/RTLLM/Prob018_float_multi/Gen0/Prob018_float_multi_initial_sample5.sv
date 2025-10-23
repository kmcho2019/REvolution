module float_multi(
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
    wire a_is_nan = &a[30:23] && |a[22:0];
    wire b_is_nan = &b[30:23] && |b[22:0];
    wire a_is_inf = &a[30:23] && ~|a[22:0];
    wire b_is_inf = &b[30:23] && ~|b[22:0];
    wire a_is_zero = ~|a[30:0];
    wire b_is_zero = ~|b[30:0];

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
                    a_exponent <= {2'b0, a[30:23]};
                    b_exponent <= {2'b0, b[30:23]};
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};

                    // Handle special cases
                    if (a_is_nan || b_is_nan) begin
                        z <= 32'h7FC00000; // Canonical NaN
                        counter <= 0;
                    end else if ((a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
                        z <= {a_sign ^ b_sign, 8'hFF, 23'h0}; // NaN (inf * 0)
                        counter <= 0;
                    end else if (a_is_inf || b_is_inf) begin
                        z <= {a_sign ^ b_sign, 8'hFF, 23'h0}; // Infinity
                        counter <= 0;
                    end else if (a_is_zero || b_is_zero) begin
                        z <= {a_sign ^ b_sign, 31'h0}; // Zero
                        counter <= 0;
                    end else begin
                        counter <= 1;
                    end
                end

                1: begin // Cycle 2: Exponent addition and mantissa multiplication
                    // Add exponents and subtract bias (127)
                    exponent_sum <= a_exponent + b_exponent - 10'd127;

                    // Multiply mantissas (24x24 = 48 bits)
                    product <= a_mantissa * b_mantissa;

                    counter <= 2;
                end

                2: begin // Cycle 3: Normalization
                    // Check if product needs normalization (bit 47 is 1)
                    if (product[47]) begin
                        product_shifted <= product;
                        exponent_sum <= exponent_sum + 1;
                    end else begin
                        product_shifted <= product << 1;
                    end

                    // Extract rounding bits
                    guard_bit <= product_shifted[22];
                    round_bit <= product_shifted[21];
                    sticky <= |product_shifted[20:0];

                    counter <= 3;
                end

                3: begin // Cycle 4: Rounding
                    // Round to nearest even
                    if (guard_bit && (round_bit || sticky || product_shifted[23])) begin
                        mantissa_rounded <= product_shifted[46:24] + 1;
                        // Check for mantissa overflow (carry into bit 24)
                        if (product_shifted[46:24] == 23'h7FFFFF) begin
                            exponent_sum <= exponent_sum + 1;
                            mantissa_rounded <= 0;
                        end
                    end else begin
                        mantissa_rounded <= product_shifted[46:24];
                    end

                    // Check for exponent overflow/underflow
                    exponent_overflow <= (exponent_sum >= 10'd255);
                    exponent_underflow <= (exponent_sum < 10'd1);

                    counter <= 4;
                end

                4: begin // Cycle 5: Final assembly
                    z_sign <= a_sign ^ b_sign;

                    if (exponent_overflow) begin
                        z_exponent <= 8'hFF;
                        z_mantissa <= 0; // Infinity
                    end else if (exponent_underflow) begin
                        z_exponent <= 0;
                        z_mantissa <= 0; // Zero (underflow)
                    end else begin
                        z_exponent <= exponent_sum[7:0];
                        z_mantissa <= mantissa_rounded;
                    end

                    // Assemble final result
                    z <= {z_sign, z_exponent, z_mantissa};

                    counter <= 0;
                end
            endcase
        end
    end

endmodule