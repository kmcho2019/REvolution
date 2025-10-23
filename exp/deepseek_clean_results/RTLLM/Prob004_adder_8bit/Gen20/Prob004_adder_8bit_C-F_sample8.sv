/**
 * 8-bit Hybrid Ripple Carry Adder
 * Combines benefits of explicit and generated implementations:
 * - First 4 bits use generate loop for compactness
 * - Last 4 bits use explicit assignments for timing optimization
 * - Maintains optimized carry computation (majority function)
 * - Clear documentation of design choices
 */
module adder_8bit (
    input [7:0] a,     // 8-bit operand A
    input [7:0] b,     // 8-bit operand B
    input cin,         // Carry-in
    output [7:0] sum,  // 8-bit sum output
    output cout        // Carry-out
);

    // Carry chain - named signals for better debugging
    wire c0, c1, c2, c3, c4, c5, c6;
    assign c0 = cin;

    // First 4 bits (0-3) implemented with generate loop
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : lower_bits
            assign sum[i] = a[i] ^ b[i] ^ ((i == 0) ? c0 : 
                         (i == 1) ? c1 : 
                         (i == 2) ? c2 : c3);
            wire next_carry = (a[i] & b[i]) | 
                            (((i == 0) ? c0 : 
                              (i == 1) ? c1 : 
                              (i == 2) ? c2 : c3) & 
                             (a[i] | b[i]));
            
            if (i == 0) assign c1 = next_carry;
            else if (i == 1) assign c2 = next_carry;
            else if (i == 2) assign c3 = next_carry;
            else assign c4 = next_carry;
        end
    endgenerate

    // Upper 4 bits (4-7) implemented explicitly for timing optimization
    // Bit 4
    assign sum[4] = a[4] ^ b[4] ^ c4;
    assign c5 = (a[4] & b[4]) | (c4 & (a[4] | b[4]));

    // Bit 5
    assign sum[5] = a[5] ^ b[5] ^ c5;
    assign c6 = (a[5] & b[5]) | (c5 & (a[5] | b[5]));

    // Bit 6
    assign sum[6] = a[6] ^ b[6] ^ c6;
    wire c7 = (a[6] & b[6]) | (c6 & (a[6] | b[6]));

    // Bit 7 (MSB with cout)
    assign sum[7] = a[7] ^ b[7] ^ c7;
    assign cout = (a[7] & b[7]) | (c7 & (a[7] | b[7]));

endmodule