module TopModule(
    input           clk,
    input           reset,
    output reg [9:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 10'd0; // Reset q to 0 if reset is high
    end else if (q == 10'd999) begin
        q <= 10'd0; // Wrap around to 0 after reaching 999
    end else begin
        q <= q + 1; // Increment q otherwise
    end
end

endmodule