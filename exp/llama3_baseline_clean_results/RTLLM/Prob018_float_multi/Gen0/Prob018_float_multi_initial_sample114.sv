module float_multi(
    input clk,        // Clock signal
    input rst,        // Reset signal (active high)
    input [31:0] a,   // First operand in IEEE 754 format
    input [31:0] b,   // Second operand in IEEE 754 format
    output reg [31:0] z // Result of the multiplication in IEEE 754 format
);

// Internal signals
reg [2:0] counter;       // Cycle counter for operation sequencing
reg [23:0] a_mantissa, b_mantissa, z_mantissa; // Mantissas of input and output numbers
reg [7:0] a_exponent, b_exponent;            // Exponents of input numbers
reg [8:0] z_exponent;                         // Exponent of output number (for intermediate calculations)
reg a_sign, b_sign, z_sign;                  // Sign bits for inputs and output
reg [49:0] product;                           // Intermediate product of the mantissas
reg guard_bit, round_bit, sticky;            // Rounding control bits

// Initialization and Input Processing
always @(posedge clk or posedge rst) begin
    if(rst) begin
        counter <= 3'b000;
        a_mantissa <= 24'd0;
        b_mantissa <= 24'd0;
        a_exponent <= 8'd0;
        b_exponent <= 8'd0;
        a_sign <= 1'b0;
        b_sign <= 1'b0;
        z_sign <= 1'b0;
    end else if (counter == 3'b000) begin
        // Extract mantissas, exponents, and sign bits
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= {1'b1, a[22:0]}; // Implicit leading 1
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= {1'b1, b[22:0]}; // Implicit leading 1
        counter <= counter + 1;
    end else if (counter == 3'b001) begin
        // Special Cases Handling (e.g., NaN, Infinity)
        if ((a_exponent == 8'hff && a_mantissa != 24'd0) || (b_exponent == 8'hff && b_mantissa != 24'd0)) begin
            // Handle NaN or Infinity
            z <= 32'h7fc00000; // Example: Result is Infinity
        end else if (a_exponent == 8'hff || b_exponent == 8'hff) begin
            // Infinity
            z <= {a_sign || b_sign, 8'h7f, 23'd0};
        end else begin
            // Normal numbers, proceed with multiplication
            counter <= counter + 1;
        end
    end else if (counter == 3'b010) begin
        // Multiplication
        product <= a_mantissa * b_mantissa;
        z_exponent <= a_exponent + b_exponent - 127; // Adjust exponent for multiplication
        counter <= counter + 1;
    end else if (counter == 3'b011) begin
        // Rounding and Adjustment
        {guard_bit, round_bit, sticky} <= product[22:20];
        if (guard_bit || round_bit || sticky) begin
            // Round up
            product <= product + 1;
        end
        z_mantissa <= product[49:26]; // Adjust mantissa
        if (product[50]) begin
            // Overflow, adjust exponent
            z_exponent <= z_exponent + 1;
            z_mantissa <= product[48:25];
        end
        counter <= counter + 1;
    end else if (counter == 3'b100) begin
        // Output Generation
        z_sign <= a_sign ^ b_sign;
        z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
        counter <= 3'b000; // Reset counter for next operation
    end
end

endmodule