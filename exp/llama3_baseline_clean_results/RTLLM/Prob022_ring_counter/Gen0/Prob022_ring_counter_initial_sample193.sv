module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

// Internal logic to handle state transitions
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Reset condition: Set the LSB to 1 and all other bits to 0
        out <= 8'b0000_0001;
    end else begin
        // Shift the '1' bit to the next position
        out <= {out[6:0], out[7]};
    end
end

endmodule