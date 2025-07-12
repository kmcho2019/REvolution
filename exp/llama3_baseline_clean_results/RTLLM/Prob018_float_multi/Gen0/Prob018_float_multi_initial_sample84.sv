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
reg [49:0] product;
reg guard_bit, round_bit, sticky;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        z_mantissa <= 24'd0;
        z_exponent <= 10'd0;
        z_sign <= 1'b0;
    end else begin
        case (counter)
            3'b000: begin // Initialization
                // Extract mantissas, exponents, and signs
                a_mantissa <= a[22:0];
                b_mantissa <= b[22:0];
                a_exponent <= a[30:23];
                b_exponent <= b[30:23];
                a_sign <= a[31];
                b_sign <= b[31];
                counter <= 3'b001;
            end
            3'b001: begin // Special cases handling
                // Check for NaN or infinity
                if ((a_exponent == 10'd255 && a_mantissa!= 24'd0) ||
                    (b_exponent == 10'd255 && b_mantissa!= 24'd0)) begin
                    // Result is NaN
                    z <= 32'd0; // Will be modified based on actual NaN handling
                end else if (a_exponent == 10'd255 || b_exponent == 10'd255) begin
                    // Result is infinity
                    z <= 32'd0; // Will be modified based on actual infinity handling
                end else begin
                    counter <= 3'b010;
                end
            end
            3'b010: begin // Normalization
                // Normalize mantissas if needed
                if (a_exponent!= 10'd0) begin
                    // No need for normalization in this implementation
                end
                counter <= 3'b011;
            end
            3'b011: begin // Multiplication
                // Multiply mantissas, combine signs, and adjust exponents
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_sign <= a_sign ^ b_sign;
                z_exponent <= a_exponent + b_exponent - 10'd127;
                counter <= 3'b100;
            end
            3'b100: begin // Rounding and adjustment
                // Round the result and adjust the exponent
                // Calculate guard bit, round bit, and sticky bit
                guard_bit <= product[1];
                round_bit <= product[2];
                sticky <= |product[2:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[49:26] + 1;
                    z_exponent <= z_exponent + 1;
                end else begin
                    z_mantissa <= product[49:26];
                end
                counter <= 3'b101;
            end
            3'b101: begin // Output generation
                // Format the final result in IEEE 754 standard
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000; // Reset counter
            end
        endcase
    end
end

endmodule