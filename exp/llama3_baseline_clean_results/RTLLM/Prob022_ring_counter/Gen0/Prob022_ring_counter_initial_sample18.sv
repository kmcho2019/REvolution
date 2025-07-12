module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize to starting state when reset
    end else begin
        // Shift the set bit to the next position, wrapping around to LSB after MSB
        out <= {out[6:0], out[7]};
    end
end

endmodule