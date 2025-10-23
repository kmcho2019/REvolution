module TopModule(
    input clk,
    input d,
    output reg q
);

reg clk_dly; // delayed clk

// Generate double frequency clock by XOR-ing clk with its delayed version
always @(posedge clk) begin
    clk_dly <= clk;
end

wire double_clk = clk ^ clk_dly;

// Register input d on double frequency clock (both edges of original clk)
always @(posedge double_clk) begin
    q <= d;
end

endmodule