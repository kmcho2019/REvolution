module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the ring counter to its starting state
        out <= 8'b0000_0001;
    end else begin
        // Shift the output to the right by one bit and wrap around to the MSB after reaching the LSB
        out <= {out[6:0], out[7]};
    end
end

endmodule