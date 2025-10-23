/**
 * Parameterized Ripple Carry Adder with optimized carry chain
 * Defaults to 8-bit operation when no width specified
 * Features:
 * - Parameterized width (default 8-bit)
 * - Optimized majority-function carry computation
 * - Explicit carry signals for better visibility
 * - Fully combinational implementation
 */
module adder_8bit #(
    parameter WIDTH = 8      // Configurable width, default 8-bit
) (
    input [WIDTH-1:0] a,    // Operand A
    input [WIDTH-1:0] b,    // Operand B
    input cin,              // Carry-in
    output [WIDTH-1:0] sum, // Sum output
    output cout             // Carry-out
);

    // Carry chain signals - one per bit plus final carry out
    wire [WIDTH:0] carry;
    
    // Initialize first carry
    assign carry[0] = cin;
    
    // Generate full adders for each bit position
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_adder
            // Sum computation: a XOR b XOR carry_in
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            
            // Optimized carry computation using majority function:
            // carry_out = (a AND b) OR (carry_in AND (a OR b))
            assign carry[i+1] = (a[i] & b[i]) | 
                               (carry[i] & (a[i] | b[i]));
        end
    endgenerate
    
    // Final carry out comes from last carry bit
    assign cout = carry[WIDTH];

    // Alternative implementation using explicit bit assignments (commented out)
    /*
    // Bit 0
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign carry[1] = (a[0] & b[0]) | (cin & (a[0] | b[0]));
    
    // Bit 1
    assign sum[1] = a[1] ^ b[1] ^ carry[1];
    assign carry[2] = (a[1] & b[1]) | (carry[1] & (a[1] | b[1]));
    
    // ... (remaining bits follow same pattern)
    
    // Bit 7
    assign sum[7] = a[7] ^ b[7] ^ carry[7];
    assign cout = (a[7] & b[7]) | (carry[7] & (a[7] | b[7]));
    */

endmodule