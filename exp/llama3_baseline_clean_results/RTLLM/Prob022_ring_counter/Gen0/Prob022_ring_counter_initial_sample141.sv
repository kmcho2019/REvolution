module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize to the starting state with LSB set
    end else begin
        // Shift the set bit to the next position, wrapping around to the start when necessary
        out <= {out[6:0], out[7]}; // Rotate the bits to the right, with MSB moving to LSB
    end
end

endmodule