module TopModule (
    input clk,
    input d,
    output reg q
);

reg clk_delayed;
wire double_edge_clock;

// Create delayed clock version
always @(posedge clk) begin
    clk_delayed <= ~clk_delayed;
end

// Generate pulses at both edges
assign double_edge_clock = clk ^ clk_delayed;

// Single flip-flop triggered on both edges
always @(posedge double_edge_clock) begin
    q <= d;
end

endmodule