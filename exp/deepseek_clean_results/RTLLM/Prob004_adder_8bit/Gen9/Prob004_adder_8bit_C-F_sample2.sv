/**
 * Parameterized Ripple Carry Adder
 * Implements combinational addition using optimized full adders
 * Features:
 * - Parameterized width (default 8-bit)
 * - Optimized carry computation
 * - Clean carry chain implementation
 * - Fully combinational logic
 */
module adder_8bit #(
    parameter WIDTH = 8      // Configurable width, default 8-bit
) (
    input [WIDTH-1:0] a,    // Operand A
    input [WIDTH-1:0] b,    // Operand B
    input cin,              // Carry-in
    output [WIDTH-1:0] sum, // Sum output
    output cout            // Carry-out
);

    // Carry chain: carry[0] = cin, carry[WIDTH] = cout
    wire [WIDTH:0] carry;
    assign carry[0] = cin;

    // Generate optimized full adders for each bit position
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : full_adder
            // Sum bit: a XOR b XOR carry_in
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            
            // Optimized carry-out computation using majority function:
            // carry_out = (a AND b) OR (carry_in AND (a OR b))
            // This implementation minimizes critical path delay
            assign carry[i+1] = (a[i] & b[i]) | 
                               (carry[i] & (a[i] | b[i]));
        end
    endgenerate

    // Final carry-out assignment
    assign cout = carry[WIDTH];

endmodule