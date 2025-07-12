module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1; // Reset to 32'h1, which means only the LSB is '1' and the rest are '0'.
    end else begin
        // Perform the shift and XOR operations for the Galois LFSR
        q[31] <= q[30] ^ q[0]; // Tap at position 31 (MSB)
        q[30:22] <= q[29:21]; // Shift right for bits without taps
        q[21] <= q[20] ^ q[0]; // Tap at position 21
        q[20:2] <= q[19:1]; // Shift right for bits without taps
        q[1] <= q[0] ^ q[0]; // This will always be q[0] due to XOR with itself
        q[0] <= q[31]; // Shift in from the MSB
    end
end

endmodule