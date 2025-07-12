module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Reset to the initial state
    end else begin
        // Rotate the bits to the right, creating the cyclic pattern
        // This is done by shifting right and then wrapping the MSB around to the LSB
        out <= {out[6:0], out[7]}; // Achieves the rotation for an 8-bit counter
    end
end

endmodule