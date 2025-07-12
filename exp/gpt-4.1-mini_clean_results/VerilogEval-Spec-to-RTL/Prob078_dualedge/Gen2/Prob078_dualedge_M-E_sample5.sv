module TopModule (
    input clk,
    input d,
    output reg q
);

reg clk2x;

// Generate a 2x frequency clock by toggling clk2x on each positive edge of clk
always @(posedge clk) begin
    clk2x <= ~clk2x;
end

// Use the generated 2x clock to trigger data sampling
always @(posedge clk2x) begin
    q <= d;
end

endmodule