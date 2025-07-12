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

// Extracting sign, exponent, and mantissa from inputs
always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
        z <= 32'b0;
    end else begin
        case (counter)
            3'b000: begin
                // Initialize and extract input components
                a_exponent <= a[30:23];
                a_mantissa <= a[22:0];
                a_sign <= a[31];
                b_exponent <= b[30:23];
                b_mantissa <= b[22:0];
                b_sign <= b[31];
                counter <= 3'b001;
            end
            3'b001: begin
                // Handle special cases (NaN, Infinity)
                if ((a_exponent == 10'b11111111) || (b_exponent == 10'b11111111)) begin
                    // Either input is NaN or Infinity, handle accordingly
                    if (a_exponent == 10'b11111111) begin
                        z <= a;
                    end else begin
                        z <= b;
                    end
                    counter <= 3'b000;
                end else if ((a_exponent == 10'b0) || (b_exponent == 10'b0)) begin
                    // Handle denormal numbers
                    // For simplicity, this example does not fully handle denormals
                    counter <= 3'b000;
                end else begin
                    counter <= 3'b010;
                end
            end
            3'b010: begin
                // Normalize mantissas if needed
                // For simplicity, assume inputs are already normalized
                // Perform multiplication and adjust exponent
                product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
                z_exponent <= a_exponent + b_exponent - 127;
                z_sign <= a_sign ^ b_sign;
                counter <= 3'b011;
            end
            3'b011: begin
                // Rounding and adjustment
                // Simplified rounding for demonstration purposes
                guard_bit <= product[48];
                round_bit <= product[47];
                sticky <= |product[46:0];
                if (guard_bit && (round_bit || sticky)) begin
                    z_mantissa <= product[46:23] + 1;
                end else begin
                    z_mantissa <= product[46:23];
                end
                // Adjust exponent if overflow
                if (product[49]) begin
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= z_mantissa >> 1;
                end
                counter <= 3'b100;
            end
            3'b100: begin
                // Format output
                z <= {z_sign, z_exponent, z_mantissa};
                counter <= 3'b000;
            end
        endcase
    end
end

endmodule