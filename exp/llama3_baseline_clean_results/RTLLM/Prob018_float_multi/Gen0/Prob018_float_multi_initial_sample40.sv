module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter; // Cycle counter for operation sequencing
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas of input and output numbers
reg [8:0] a_exponent, b_exponent, z_exponent; // Exponents of input and output numbers
reg a_sign, b_sign, z_sign; // Sign bits for inputs and output
reg [49:0] product; // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

always @(*) begin
    // Extract mantissas, exponents, and sign bits
    a_mantissa = a[22:0];
    a_exponent = a[30:23];
    a_sign = a[31];

    b_mantissa = b[22:0];
    b_exponent = b[30:23];
    b_sign = b[31];
end

always @(posedge clk) begin
    if (rst) begin
        // Reset the counter
        counter <= 0;
        z <= 0;
    end else begin
        case (counter)
            0: begin
                // Initialize the output and counter
                z_sign = a_sign ^ b_sign;
                z_exponent = a_exponent + b_exponent - 127; // Combine exponents
                counter <= 1;
            end
            1: begin
                // Handle special cases
                if ((a_exponent == 255 && a_mantissa != 0) || (b_exponent == 255 && b_mantissa != 0)) begin
                    // NaN or infinity
                    z <= (a_exponent == 255) ? a : b;
                end else if ((a_exponent == 0 && a_mantissa == 0) || (b_exponent == 0 && b_mantissa == 0)) begin
                    // Zero
                    z <= 0;
                end else begin
                    // Normalize mantissas
                    a_mantissa = {1'b1, a_mantissa};
                    b_mantissa = {1'b1, b_mantissa};

                    // Multiply mantissas
                    product = a_mantissa * b_mantissa;

                    // Round the product
                    guard_bit = product[23];
                    round_bit = product[22];
                    sticky = |product[21:0];

                    // Adjust the exponent
                    if (product[49]) begin
                        z_exponent = z_exponent + 1;
                    end

                    counter <= 2;
                end
            end
            2: begin
                // Perform rounding and adjustment
                if (guard_bit && (round_bit || sticky)) begin
                    // Round up
                    z_mantissa = product[48:25] + 1;
                    if (z_mantissa == 0) begin
                        z_exponent = z_exponent + 1;
                    end
                end else begin
                    // Round down
                    z_mantissa = product[48:25];
                end

                // Format the output
                z <= {z_sign, z_exponent, z_mantissa};

                counter <= 0;
            end
        endcase
    end
end

endmodule