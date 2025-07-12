module TopModule (
    input clk,
    input d,
    output reg q
);

// Explicitly show the positive edge detection and data capture
wire posedge_clk;
reg prev_clk;

always @(clk) begin
    prev_clk <= clk;
end

assign posedge_clk = clk & ~prev_clk;

always @(posedge_clk) begin
    q <= d;
end

endmodule