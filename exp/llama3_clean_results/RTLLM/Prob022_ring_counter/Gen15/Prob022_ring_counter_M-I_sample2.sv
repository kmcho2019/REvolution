module ring_counter(
    input  wire clk,
    input  wire reset,
    output reg  [7:0] out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize output to the starting state
        out <= 8'b0000_0001;
    end else begin
        // Shift the output one bit to the right and wrap around
        out <= {out[0], out[7:1]};
    end
end

endmodule