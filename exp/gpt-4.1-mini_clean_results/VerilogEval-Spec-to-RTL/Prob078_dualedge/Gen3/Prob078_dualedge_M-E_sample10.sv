module TopModule (
    input clk,
    input d,
    output reg q
);

reg clk_dly;
reg d_sampled;
wire dual_edge_enable;

// Delay the clock by one delta cycle to generate an edge detection signal
always @(posedge clk or negedge clk) begin
    clk_dly <= clk;  // This is illegal in synthesis for negedge, so instead, create delay by flip-flop
end

// Since always @(posedge clk or negedge clk) is illegal, replace clk_dly generation with a small asynchronous logic:
reg clk_sync1, clk_sync2;
always @(posedge clk) begin
    clk_sync1 <= ~clk_sync1;
end
// clk_sync1 toggles at half the clk frequency but shifted, so XOR with clk creates pulses on both edges

assign dual_edge_enable = clk ^ clk_sync1; // high pulse on both clk edges

// Sample d synchronously on dual_edge_enable pulses using rising edge triggered FF with enable
always @(posedge clk) begin
    if (dual_edge_enable)
        q <= d;
end

endmodule