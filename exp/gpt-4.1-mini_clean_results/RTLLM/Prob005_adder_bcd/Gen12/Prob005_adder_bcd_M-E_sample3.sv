module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Step 1: Binary addition with 5-bit width to get carry out
    wire [4:0] bin_sum = A + B + Cin;

    // Step 2: Determine if correction needed (sum > 9 or carry out)
    // sum > 9 means (bin_sum[4] == 1) or (bin_sum[3] == 1 and at least one of bin_sum[2] or bin_sum[1] is 1)
    wire correction_needed = bin_sum[4] | (bin_sum[3] & (bin_sum[2] | bin_sum[1]));

    // Step 3: Compute corrected sum by adding 6 (0110) if correction is needed
    // Instead of a full adder, use bitwise correction logic:
    // Correction adds 0110, so:
    // Bit 0 of sum remains unchanged (no correction addition in bit 0)
    // Bit 1 flips if correction needed and bin_sum[1]==0, else remains set if bin_sum[1]==1
    // Bit 2 flips similarly, and bit 3 may toggle due to carry within addition of 6
    
    // We'll simulate addition of 6 by bitwise logic using XOR and AND:
    // Adding 6 = adding 0 at bit0, 1 at bit1, 1 at bit2, 0 at bit3 with carry propagation

    wire c0 = correction_needed & bin_sum[0]; // carry from bit0 addition (0 + bit0 + carry_in=0)
    wire sum_bit0 = bin_sum[0];               // bit0 unchanged as 6's LSB is 0

    wire sum_bit1 = bin_sum[1] ^ correction_needed;               // bit1 XOR correction bit
    wire c1 = (bin_sum[1] & correction_needed);                   // carry from bit1

    wire sum_bit2 = bin_sum[2] ^ correction_needed ^ c1;          // bit2 + correction + carry from bit1
    wire c2 = (bin_sum[2] & correction_needed) | (bin_sum[2] & c1) | (correction_needed & c1);

    wire sum_bit3 = bin_sum[3] ^ c2;                              // bit3 + carry from bit2
    wire c3 = bin_sum[3] & c2;

    assign Sum = {sum_bit3, sum_bit2, sum_bit1, sum_bit0};
    assign Cout = bin_sum[4] | c3; // carry out is original carry or carry from correction addition

endmodule