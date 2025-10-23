module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [8:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

always @(posedge clk) begin
    if (rst) begin
        // Reset the counter and internal signals
        counter <= 3'b000;
        z_mantissa <= 24'd0;
        z_exponent <= 9'd0;
        z_sign <= 1'b0;
        guard_bit <= 1'b0;
        round_bit <= 1'b0;
        sticky <= 1'b0;
    end else begin
        case (counter)
            3'b000: begin
                // Input processing: Extract mantissas, exponents, and signs
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                z_sign <= a_sign ^ b_sign; // Calculate the sign of the result

                // Identify special cases (NaN, infinity)
                if ((a_exponent == 9'hFF && a_mantissa!= 24'd0) ||
                    (b_exponent == 9'hFF && b_mantissa!= 24'd0)) begin
                    // Handle NaN (result is NaN)
                    z <= 32'h7FC00000;
                end else if ((a_exponent == 9'hFF && a_mantissa == 24'd0) ||
                             (b_exponent == 9'hFF && b_mantissa == 24'd0)) begin
                    // Handle infinity (result is infinity with correct sign)
                    if (a_sign ^ b_sign) begin
                        z <= 32'hFF800000;
                    end else begin
                        z <= 32'h7F800000;
                    end
                end else begin
                    // Increment the counter to proceed with multiplication
                    counter <= counter + 1;
                end
            end
            3'b001: begin
                // Normalize the mantissas if necessary
                if (a_mantissa[23] == 1'b0) begin
                    // Normalize a_mantissa
                    a_mantissa <= a_mantissa << 1;
                    a_exponent <= a_exponent - 1'b1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    // Normalize b_mantissa
                    b_mantissa <= b_mantissa << 1;
                    b_exponent <= b_exponent - 1'b1;
                end

                // Increment the counter to proceed with multiplication
                counter <= counter + 1;
            end
            3'b010: begin
                // Multiply the mantissas
                product <= (a_mantissa + 24'd1) * (b_mantissa + 24'd1);

                // Calculate the new exponent
                z_exponent <= a_exponent + b_exponent + 1'b1;

                // Increment the counter to proceed with rounding and adjustment
                counter <= counter + 1;
            end
            3'b011: begin
                // Extract guard, round, and sticky bits from the product
                guard_bit <= product[1];
                round_bit <= product[0];
                sticky <= product[0] || product[48:2]!= 47'd0;

                // Rounding and adjustment
                if (guard_bit && (round_bit || sticky)) begin
                    // Round up (add 1 to the result)
                    z_mantissa <= product[49:26] + 1'b1;
                    if (z_mantissa[23] == 1'b1) begin
                        // Overflow: Adjust the exponent
                        z_exponent <= z_exponent + 1'b1;
                        z_mantissa <= z_mantissa >> 1;
                    end
                end else begin
                    // Round down (no change to the result)
                    z_mantissa <= product[49:26];
                end

                // Increment the counter to proceed with output generation
                counter <= counter + 1;
            end
            3'b100: begin
                // Output generation: Format the result according to IEEE 754 standard
                z <= {z_sign, z_exponent, z_mantissa};

                // Reset the counter for the next operation
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule