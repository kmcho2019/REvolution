module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter; // Cycle counter
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas
reg [7:0] a_exponent, b_exponent, z_exponent; // Exponents
reg a_sign, b_sign, z_sign; // Sign bits
reg [49:0] product; // Intermediate product of mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// Initialization
always @(posedge clk) begin
    if (rst) begin
        counter <= 0;
        z <= 32'd0;
    end else begin
        // Input Processing
        if (counter == 0) begin
            // Extract mantissas, exponents, and signs
            a_mantissa <= a[22:0];
            b_mantissa <= b[22:0];
            a_exponent <= a[30:23];
            b_exponent <= b[30:23];
            a_sign <= a[31];
            b_sign <= b[31];
            // Special cases handling
            if ((a_exponent == 8'd255 && a_mantissa != 0) || (b_exponent == 8'd255 && b_mantissa != 0)) begin
                z <= (a[31] || b[31]) ? 32'hFFC00000 : 32'h7FC00000; // NaN or infinity
            end else if ((a_exponent == 0 && a_mantissa == 0) || (b_exponent == 0 && b_mantissa == 0)) begin
                z <= 32'd0; // Zero
            end else begin
                counter <= counter + 1;
            end
        // Normalization and Multiplication
        end else if (counter == 1) begin
            // Normalize mantissas if needed
            if (a_exponent == 0) begin
                a_mantissa <= a_mantissa << 1;
                a_exponent <= a_exponent + 1;
            end
            if (b_exponent == 0) begin
                b_mantissa <= b_mantissa << 1;
                b_exponent <= b_exponent + 1;
            end
            // Multiply mantissas
            product <= a_mantissa * b_mantissa;
            z_exponent <= a_exponent + b_exponent - 127; // Adjust exponent
            z_sign <= a_sign ^ b_sign; // Combine signs
            counter <= counter + 1;
        // Rounding and Adjustment
        end else if (counter == 2) begin
            // Rounding
            guard_bit <= product[48];
            round_bit <= product[47];
            sticky <= |product[46:0];
            if (guard_bit && (round_bit || sticky)) begin
                z_mantissa <= product[46:23] + 1;
            end else begin
                z_mantissa <= product[46:23];
            end
            // Adjust exponent
            if (z_mantissa[23]) begin
                z_exponent <= z_exponent + 1;
                z_mantissa <= z_mantissa >> 1;
            end
            counter <= counter + 1;
        // Output Generation
        end else if (counter == 3) begin
            // Format result in IEEE 754 standard
            z <= {z_sign, z_exponent, z_mantissa};
            // Handle overflow and underflow
            if (z_exponent > 8'd255 - 1) begin
                z <= (z_sign) ? 32'hFFC00000 : 32'h7FC00000; // Infinity
            end else if (z_exponent < 1) begin
                z <= {z_sign, 8'd0, z_mantissa}; // Subnormal
            end
            counter <= 0;
        end
    end
end

endmodule