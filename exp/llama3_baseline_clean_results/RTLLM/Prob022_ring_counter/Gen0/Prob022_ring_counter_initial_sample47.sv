module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the counter to its starting state when reset is high
        out <= 8'b0000_0001;
    end else begin
        // Update the current state by shifting the set bit to the next position
        out <= {out[6:0], out[7]};
    end
end

endmodule