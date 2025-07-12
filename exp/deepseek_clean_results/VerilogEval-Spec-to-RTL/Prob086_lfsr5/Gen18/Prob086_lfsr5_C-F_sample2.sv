module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

// 5-bit maximal-length Galois LFSR with taps at positions 5 (q[4]) and 3 (q[2])
// Feedback: XOR tap positions with q[0] (LSB)
// Reset value: 5'b00001 (active high synchronous reset)

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        q <= {q[0],          // New MSB is old LSB
              q[4],           // Shift right
              q[3] ^ q[0],   // Tap at position 4 (5 in 1-based)
              q[2],           // Shift right
              q[1]};          // Shift right
    end
end

endmodule