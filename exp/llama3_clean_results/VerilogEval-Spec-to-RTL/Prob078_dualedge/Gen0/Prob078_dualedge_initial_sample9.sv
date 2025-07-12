module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_rising;
reg q_falling;

always @(posedge clk)
    q_rising <= d;

always @(negedge clk)
    q_falling <= d;

always @(*)
    q <= q_rising || q_falling;

endmodule