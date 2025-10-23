module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Reset to initial state (LSB set to 1)
    end else begin
        // Correctly implement cyclic shift
        out <= {out[6:0], out[7]}; // Shift register to the right and wrap MSB around to LSB
    end
end

endmodule