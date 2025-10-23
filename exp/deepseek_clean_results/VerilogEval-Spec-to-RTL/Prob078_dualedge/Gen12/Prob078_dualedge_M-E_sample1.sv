module TopModule (
    input clk,
    input d,
    output reg q
);

reg clk_delayed;
wire clock_edge;

// Create delayed clock version
always @(posedge clk or negedge clk) begin
    clk_delayed <= clk;
end

// Edge detector (works for both rising and falling)
assign clock_edge = clk ^ clk_delayed;

// Dual-edge triggered behavior
always @(posedge clock_edge) begin
    q <= d;
end

endmodule