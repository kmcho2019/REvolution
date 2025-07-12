module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize out with the LSB set to 1
    end else begin
        // Shift the bits to the right, wrapping around to the MSB
        out <= {out[6:0], out[7]};
    end
end

endmodule