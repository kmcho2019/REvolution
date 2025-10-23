module TopModule(
    input clk,
    input d,
    output reg q
);

// Use two separate always blocks to capture data on both edges of the clock
always @(posedge clk)
    q <= d;

always @(negedge clk)
    q <= d;

endmodule