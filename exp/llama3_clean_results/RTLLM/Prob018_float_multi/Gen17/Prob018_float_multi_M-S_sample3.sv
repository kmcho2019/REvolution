module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter; // Cycle counter for operation sequencing
reg [22:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas of input and output numbers
reg [7:0] a_exponent, b_exponent, z_exponent; // Exponents of input and output numbers
reg a_sign, b_sign, z_sign; // Sign bits for inputs and output
reg [45:0] product; // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky; // Rounding control bits

// Initialization
always @(posedge clk) begin
    if (rst) begin
        counter <= 3'b000;
        a_mantissa <= 0;
        a_exponent <= 0;
        a_sign <= 0;
        b_mantissa <= 0;
        b_exponent <= 0;
        b_sign <= 0;
    end
end

// Input Processing
always @(posedge clk) begin
    if (counter == 3'b000) begin
        // Extract mantissas, exponents, and signs from inputs
        a_mantissa <= a[22:0];
        a_exponent <= a[30:23];
        a_sign <= a[31];
        b_mantissa <= b[22:0];
        b_exponent <= b[30:23];
        b_sign <= b[31];
        counter <= counter + 1;
    end
end

// Special Cases Handling
always @(posedge clk) begin
    if (counter == 3'b001) begin
        // Handle special cases like NaN and infinity
        if (a_exponent == 8'd255 || b_exponent == 8'd255) begin
            if (a_exponent == 8'd255 && a_mantissa != 0) begin
                z <= 32'd0; // NaN
            end else if (b_exponent == 8'd255 && b_mantissa != 0) begin
                z <= 32'd0; // NaN
            end else if (a_exponent == 8'd255 && a_mantissa == 0) begin
                z <= {a_sign, 8'd255, 23'd0}; // Infinity
            end else if (b_exponent == 8'd255 && b_mantissa == 0) begin
                z <= {b_sign, 8'd255, 23'd0}; // Infinity
            end
        end else begin
            counter <= counter + 1;
        end
    end
end

// Multiplication
always @(posedge clk) begin
    if (counter == 3'b010) begin
        // Multiply mantissas
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
        counter <= counter + 1;
    end
end

// Rounding and Adjustment
always @(posedge clk) begin
    if (counter == 3'b011) begin
        // Round the result and adjust the exponent
        z_mantissa <= product[45:23];
        z_exponent <= a_exponent + b_exponent - 8'd127;
        z_sign <= a_sign ^ b_sign;
        counter <= counter + 1;
    end
end

// Output Generation
always @(posedge clk) begin
    if (counter == 3'b100) begin
        // Generate output in IEEE 754 format
        z <= {z_sign, z_exponent, z_mantissa};
        counter <= 3'b000; // Reset counter
    end
end

endmodule