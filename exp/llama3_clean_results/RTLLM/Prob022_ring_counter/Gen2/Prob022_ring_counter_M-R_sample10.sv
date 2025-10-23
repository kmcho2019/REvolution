module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

// Update state on clock edge with reset
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset to initial state
        out <= 8'b0000_0001;
    end else begin
        // Perform cyclic shift
        out <= (out >> 1) | (out[0] << 7); // Shift right and wrap around
    end
end

endmodule