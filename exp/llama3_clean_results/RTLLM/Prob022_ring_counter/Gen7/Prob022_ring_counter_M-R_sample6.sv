module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001; // Initialize out with the LSB set to 1
    end else begin
        out <= {out[7], out[6:0]}; // Shift the bits to the right and wrap around
    end
end

endmodule