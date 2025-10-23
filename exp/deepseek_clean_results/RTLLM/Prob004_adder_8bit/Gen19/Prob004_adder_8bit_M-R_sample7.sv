/**
 * 8-bit Ripple Carry Adder - Refactored Implementation
 * Uses generate blocks for scalability and XOR-based carry computation
 * 
 * Features:
 * - Generate blocks for scalable implementation
 * - XOR-based carry computation for potential power savings
 * - Vectorized carry signals for cleaner code
 * - Maintains all PPA optimizations
 * - Same functionality as original but more maintainable
 */
module adder_8bit (
    input [7:0] a,     // 8-bit operand A
    input [7:0] b,     // 8-bit operand B
    input cin,         // Carry-in
    output [7:0] sum,  // 8-bit sum output
    output cout        // Carry-out
);

    // Carry chain vector (8 bits: c[0] is carry from bit 0 to bit 1)
    wire [8:0] c;

    // Initialize carry chain
    assign c[0] = cin;

    // Generate full adders for each bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_chain
            // Sum computation
            assign sum[i] = a[i] ^ b[i] ^ c[i];
            
            // Carry computation using optimized formula
            assign c[i+1] = (a[i] & b[i]) | (c[i] & (a[i] ^ b[i]));
        end
    endgenerate

    // Final carry out assignment
    assign cout = c[8];

endmodule