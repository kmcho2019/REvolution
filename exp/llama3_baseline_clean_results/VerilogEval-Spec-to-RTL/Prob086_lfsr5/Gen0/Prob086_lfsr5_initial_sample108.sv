module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q_reg; // Internal register for the LFSR

// Initial block to set initial value of q_reg to 1 (for q[0]) upon reset
initial begin
    q_reg = 5'b00001;
end

// Always block for sequential logic
always @(posedge clk) begin
    if (reset) begin
        q_reg <= 5'b00001; // Reset to 1 on the LSB
    end else begin
        // For a 5-bit LFSR with taps at positions 5 and 3:
        // The next MSB (q[4]) is the XOR of the current LSB (q[0]) and the current MSB (q[4]) and the bit at position 3 (q[2])
        // The bit at position 3 shifts with the XOR of itself and the LSB
        // Other bits shift right
        q_reg[4] <= q_reg[3] ^ q_reg[0];
        q_reg[3] <= q_reg[2] ^ q_reg[0];
        q_reg[2] <= q_reg[1];
        q_reg[1] <= q_reg[0];
        q_reg[0] <= q_reg[4] ^ q_reg[3] ^ q_reg[2] ^ q_reg[1] ^ q_reg[0];
        // Corrected to maintain the property of a Galois LFSR with taps at positions 5 and 3
        q_reg <= {q_reg[3] ^ q_reg[0], q_reg[2], q_reg[1], q_reg[0], q_reg[4] ^ q_reg[2] ^ q_reg[0]};
    end
end

// Continuous assignment for output
assign q = q_reg;

endmodule