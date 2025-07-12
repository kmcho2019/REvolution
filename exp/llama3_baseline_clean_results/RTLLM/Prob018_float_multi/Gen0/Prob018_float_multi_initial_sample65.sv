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

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        z <= 0;
    end else if (counter == 0) begin
        // Input Processing
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= a[22:0];
        
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= b[22:0];
        
        counter <= 1;
    end else if (counter == 1) begin
        // Special Cases Handling
        if ((a_exponent == 9'd255 && a_mantissa != 0) || (b_exponent == 9'd255 && b_mantissa != 0)) begin
            // NaN or infinity handling
            z_sign <= a_sign ^ b_sign;
            z_exponent <= 9'd255;
            if (a_mantissa != 0 || b_mantissa != 0) begin
                z_mantissa <= 24'd1;
            end else begin
                z_mantissa <= 0;
            end
            counter <= 5; // Skip to output generation
        end else if (a_exponent == 9'd255 || b_exponent == 9'd255) begin
            // Infinity handling
            z_sign <= a_sign ^ b_sign;
            z_exponent <= 9'd255;
            z_mantissa <= 0;
            counter <= 5; // Skip to output generation
        end else begin
            counter <= 2;
        end
    end else if (counter == 2) begin
        // Normalization
        if (a_exponent == 0 && a_mantissa[23] == 0) begin
            // Normalize a
            a_mantissa <= a_mantissa << 1;
            a_exponent <= a_exponent - 1;
        end
        if (b_exponent == 0 && b_mantissa[23] == 0) begin
            // Normalize b
            b_mantissa <= b_mantissa << 1;
            b_exponent <= b_exponent - 1;
        end
        counter <= 3;
    end else if (counter == 3) begin
        // Multiplication
        z_sign <= a_sign ^ b_sign;
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
        z_exponent <= a_exponent + b_exponent - 127;
        counter <= 4;
    end else if (counter == 4) begin
        // Rounding and Adjustment
        z_mantissa <= product[49:26];
        guard_bit <= product[25];
        round_bit <= product[24];
        sticky <= |product[23:0];
        
        if (guard_bit && (round_bit || sticky)) begin
            z_mantissa <= z_mantissa + 1;
            if (z_mantissa[23] == 1) begin
                z_exponent <= z_exponent + 1;
                z_mantissa <= z_mantissa >> 1;
            end
        end
        
        if (z_exponent > 255) begin
            // Overflow
            z_exponent <= 9'd255;
            z_mantissa <= 0;
        end else if (z_exponent < -126) begin
            // Underflow
            z_exponent <= 0;
            z_mantissa <= 0;
        end
        counter <= 5;
    end else if (counter == 5) begin
        // Output Generation
        z <= {z_sign, z_exponent, z_mantissa};
        counter <= 0;
    end
end

endmodule