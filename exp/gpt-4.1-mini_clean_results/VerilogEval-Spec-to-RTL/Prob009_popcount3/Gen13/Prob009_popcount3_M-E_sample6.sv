module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire [1:0] partial_count;

    // Count ones in first two bits (in[1], in[0])
    // The count of two bits can be 0,1, or 2
    // Use a 2-bit value: bit0 = XOR (parity), bit1 = AND (both bits set)
    assign partial_count[0] = in[0] ^ in[1];  // bit0 of partial sum
    assign partial_count[1] = in[0] & in[1];  // bit1 of partial sum

    // Add third bit to partial_count
    // partial_count + in[2]
    // Since partial_count ranges from 0 to 2, adding 0 or 1 results in 0 to 3
    // Implement addition using simple logic:
    // sum bit 0 = partial_count[0] ^ in[2]
    // carry out = partial_count[1] | (partial_count[0] & in[2])
    assign out[0] = partial_count[0] ^ in[2];
    assign out[1] = partial_count[1] | (partial_count[0] & in[2]);

endmodule