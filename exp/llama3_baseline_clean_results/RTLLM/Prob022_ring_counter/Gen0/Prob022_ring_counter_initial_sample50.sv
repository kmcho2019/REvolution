module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

// Initialize the output to its starting state when reset is high
always @(*) begin
    if (reset) begin
        out <= 8'b0000_0001; // Set the least significant bit to 1 and all other bits to 0
    end else begin
        // Shift the current state one bit to the right and connect the most significant bit back to the least significant bit
        out <= {out[6:0], out[7]};
    end
end

// No sequential logic is required as the state transition is handled by the combinational logic above

endmodule