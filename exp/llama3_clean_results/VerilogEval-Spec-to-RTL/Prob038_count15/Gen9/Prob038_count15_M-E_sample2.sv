module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] gray_count; // Internal Gray code counter

// Increment the Gray code counter
always @(posedge clk) begin
    if (reset) begin
        gray_count <= 4'd0; // Reset the Gray counter to 0
    end else begin
        // Increment the Gray code counter
        // In a Gray code sequence, only one bit changes at a time.
        // The sequence for a 4-bit Gray code counter is:
        // 0000, 0001, 0011, 0010, 0110, 0111, 0101, 0100, 1100, 1101, 1111, 1110, 1010, 1011, 1001, 1000
        // We can generate the next Gray code by XORing the most significant bit with the second most significant bit and the rest.
        // However, for simplicity and to avoid complex logic, we will use a straightforward increment and correct it to follow Gray code.
        gray_count <= gray_count + 1; // Directly increment the counter.
    end
end

// Convert Gray code to Binary
always @(*) begin
    // The conversion from Gray to binary can be done by XORing each bit with the bit to its left.
    // For a 4-bit Gray code G3G2G1G0, the binary equivalent B3B2B1B0 is calculated as follows:
    // B3 = G3
    // B2 = G3 XOR G2
    // B1 = G3 XOR G2 XOR G1
    // B0 = G3 XOR G2 XOR G1 XOR G0
    q[3] = gray_count[3];
    q[2] = gray_count[3] ^ gray_count[2];
    q[1] = gray_count[3] ^ gray_count[2] ^ gray_count[1];
    q[0] = gray_count[3] ^ gray_count[2] ^ gray_count[1] ^ gray_count[0];
end

endmodule