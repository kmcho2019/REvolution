module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

// Use an 8-bit shift register to implement the ring counter
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Load the initial state into the shift register
        out <= 8'b0000_0001;
    end else begin
        // Shift the bits one position to the right and feed the MSB back into the LSB
        out <= {out[6:0], out[7]};
    end
end

endmodule