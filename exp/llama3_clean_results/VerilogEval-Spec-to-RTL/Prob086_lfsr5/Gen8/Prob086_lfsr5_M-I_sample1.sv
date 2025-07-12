module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @ (posedge clk) begin
    if (reset) begin
        // Reset q to a non-zero value, typically the highest bit set
        q <= 5'b10000; 
    end else begin
        // Correct LFSR next state calculation for a Galois LFSR with taps at 5 and 3
        // The most significant bit (MSB) is calculated as the XOR of the current MSB (q[4]), 
        // the bit at position 3 (q[2]), and the least significant bit (LSB) (q[0])
        q <= {q[4] ^ q[2] ^ q[0], q[4:1]};
    end
end

endmodule