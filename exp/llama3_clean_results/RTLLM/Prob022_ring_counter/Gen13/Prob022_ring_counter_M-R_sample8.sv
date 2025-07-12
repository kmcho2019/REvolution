module ring_counter(
    input  wire clk,
    input  wire reset,
    output reg  [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset output to initial state (LSB set to 1)
        out <= 8'b0000_0001;
    end else begin
        // Shift output one position to the right and set MSB if necessary
        out <= {out[6:0], out[7]};
    end
end

endmodule