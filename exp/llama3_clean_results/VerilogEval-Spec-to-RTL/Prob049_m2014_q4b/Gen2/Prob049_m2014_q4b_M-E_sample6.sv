module TopModule(
    input clk,
    input ar,
    input d,
    output reg q
);

reg async_reset_triggered;

always @(posedge clk)
    if (ar) async_reset_triggered <= 1'b1; else if (!ar && async_reset_triggered) async_reset_triggered <= 1'b0;

always @(posedge clk or posedge ar)
    if (ar || async_reset_triggered) q <= 1'b0; else q <= d;

endmodule