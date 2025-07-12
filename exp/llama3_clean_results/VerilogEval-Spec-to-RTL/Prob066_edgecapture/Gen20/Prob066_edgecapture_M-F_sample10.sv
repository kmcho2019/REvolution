module TopModule(
    input  clk,
    input  reset,
    input  [31:0] in,
    output reg [31:0] out
);

reg [31:0] previous_in;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'd0;
        previous_in <= 32'd0;
    end else begin
        reg [31:0] new_edges;
        new_edges = previous_in & ~in; // Correctly detect falling edges
        out <= out | new_edges; // Update output with new edges
        previous_in <= in;
    end
end

endmodule