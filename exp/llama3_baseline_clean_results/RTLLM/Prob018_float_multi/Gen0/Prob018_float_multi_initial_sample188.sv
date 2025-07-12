module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter; // Cycle counter for operation sequencing
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas of input and output numbers
reg [9:0] a_exponent, b_exponent, z_exponent; // Exponents of input and output numbers
reg a_sign, b_sign, z_sign; // Sign bits for inputs and output
reg [49:0] product; // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
        a_mantissa <= 24'b0;
        b_mantissa <= 24'b0;
        z_mantissa <= 24'b0;
        a_exponent <= 10'b0;
        b_exponent <= 10'b0;
        z_exponent <= 10'b0;
        a_sign <= 1'b0;
        b_sign <= 1'b0;
        z_sign <= 1'b0;
        product <= 50'b0;
        guard_bit <= 1'b0;
        round_bit <= 1'b0;
        sticky <= 1'b0;
        z <= 32'b0;
    end else begin
        // Input processing
        if (counter == 3'b000) begin
            // Extract mantissas, exponents, and signs from inputs
            a_mantissa <= {1'b1, a[22:0]};
            b_mantissa <= {1'b1, b[22:0]};
            a_exponent <= a[30:23];
            b_exponent <= b[30:23];
            a_sign <= a[31];
            b_sign <= b[31];
            counter <= counter + 1'b1;
        end
        // Special cases handling and normalization
        else if (counter == 3'b001) begin
            // Check for NaN and infinity
            if ((a_exponent == 10'b1111111111 && a_mantissa != 24'b0) ||
                (b_exponent == 10'b1111111111 && b_mantissa != 24'b0)) begin
                // Handle NaN or infinity
                if (a_exponent == 10'b1111111111 && a_mantissa != 24'b0)
                    z <= a;
                else if (b_exponent == 10'b1111111111 && b_mantissa != 24'b0)
                    z <= b;
                else
                    z <= 32'b0; // Default for infinity or NaN
            end else begin
                // Normalize mantissas if needed
                if (a_mantissa[23] == 1'b0) begin
                    // Normalize a
                    a_mantissa <= {a_mantissa[22:0], 1'b0} << 1;
                    a_exponent <= a_exponent - 10'b1;
                end
                if (b_mantissa[23] == 1'b0) begin
                    // Normalize b
                    b_mantissa <= {b_mantissa[22:0], 1'b0} << 1;
                    b_exponent <= b_exponent - 10'b1;
                end
                counter <= counter + 1'b1;
            end
        end
        // Multiplication and rounding
        else if (counter == 3'b010) begin
            // Multiply mantissas
            product <= a_mantissa * b_mantissa;
            // Adjust exponent
            z_exponent <= a_exponent + b_exponent - 10'b127;
            // Determine sign of result
            z_sign <= a_sign ^ b_sign;
            counter <= counter + 1'b1;
        end
        // Finalize result
        else if (counter == 3'b011) begin
            // Rounding and normalization
            {guard_bit, round_bit, sticky} <= product[49:47];
            if (guard_bit && (round_bit || sticky))
                z_mantissa <= product[46:23] + 1'b1;
            else
                z_mantissa <= product[46:23];
            // Handle overflow and underflow
            if (z_exponent > 10'b1111111101)
                z <= {1'b1, 10'b1111111111, 23'b0}; // Overflow
            else if (z_exponent < 10'b1)
                z <= {z_sign, 10'b0, z_mantissa[22:0]}; // Underflow
            else
                z <= {z_sign, z_exponent, z_mantissa[22:0]};
            counter <= 3'b000; // Reset counter
        end
    end
end

endmodule