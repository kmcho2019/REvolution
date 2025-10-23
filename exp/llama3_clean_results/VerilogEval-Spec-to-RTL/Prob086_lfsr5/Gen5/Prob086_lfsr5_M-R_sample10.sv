module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Update the state on the positive edge of the clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the LFSR output to 1 (set all bits to 0 except the least significant bit to 1)
        q <= 5'b00001;
    end else begin
        // Calculate the next state directly
        // The most significant bit (q[4]) is the XOR of the least significant bit (q[0]) and the bit at position 5 (q[4])
        q[4] <= q[3] ^ q[0]; // Tap at position 5
        // The bit at position 3 (q[2]) is the XOR of the least significant bit (q[0]) and the bit at position 3 (q[2])
        q[3] <= q[2];
        q[2] <= q[1] ^ q[0]; // Tap at position 3
        q[1] <= q[0];
        q[0] <= q[4]; // Shift the least significant bit
    end
end

endmodule