module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset to initial state (LSB set to 1)
        out <= 8'b0000_0001;
    end else begin
        // Shift register to the right and wrap MSB around to LSB
        out <= {out[6:0], out[7]};
    end
end

endmodule