module TopModule(
    input clk,
    input d,
    output reg q
);

reg internal_clk;  // Internal clock signal for dual-edge triggering

// Generate internal clock with pulses at both positive and negative edges
always @(posedge clk or negedge clk) begin
    internal_clk <= ~internal_clk;
end

// Single flip-flop triggered by the internal clock
always @(posedge internal_clk) begin
    q <= d;
end

endmodule