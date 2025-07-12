module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

// Initialize the output to its starting state when reset is high
always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Reset the counter to its initial state
    end else begin
        // Shift the set bit to the next position in a cyclic manner
        out <= {out[6:0], out[7]};
    end
end

endmodule