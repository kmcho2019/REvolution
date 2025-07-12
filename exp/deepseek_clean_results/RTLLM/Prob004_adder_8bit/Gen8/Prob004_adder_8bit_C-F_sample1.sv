/**
 * 8-bit Ripple Carry Adder with parameterized width
 * Implements combinational addition using full adders
 * Optimized carry computation using majority function
 */
module adder_8bit #(
    parameter WIDTH = 8      // Default to 8-bit width
) (
    input [WIDTH-1:0] a,    // Operand A
    input [WIDTH-1:0] b,    // Operand B
    input cin,              // Carry-in
    output [WIDTH-1:0] sum, // Sum output
    output cout             // Carry-out
);

    // Carry chain: carry[i] is the carry-in for bit i
    // carry[0] = cin, carry[WIDTH] = cout
    wire [WIDTH:0] carry;
    
    // Initialize carry chain
    assign carry[0] = cin;
    
    // Generate full adders for each bit position
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_adder
            // Sum computation: a XOR b XOR carry_in
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            
            // Optimized carry computation using majority function:
            // carry_out = (a AND b) OR (carry_in AND (a OR b))
            // This implementation minimizes critical path delay
            assign carry[i+1] = (a[i] & b[i]) | 
                              (carry[i] & (a[i] | b[i]));
        end
    endgenerate
    
    // Final carry out comes from last carry bit
    assign cout = carry[WIDTH];

endmodule