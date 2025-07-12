module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

// Use an always block to handle the sequential logic (state transitions)
always @(posedge clk or posedge reset) begin
    // If reset is high, initialize the counter to its starting state
    if (reset) begin
        out <= 8'b0000_0001; // Reset to the initial state
    end else begin
        // Perform a cyclic shift of the bits
        // This is achieved by shifting all bits one position to the right
        // and then moving the MSB (most significant bit) to the LSB (least significant bit)
        out <= {out[6:0], out[7]}; // Directly shift the bits of out
    end
end

endmodule