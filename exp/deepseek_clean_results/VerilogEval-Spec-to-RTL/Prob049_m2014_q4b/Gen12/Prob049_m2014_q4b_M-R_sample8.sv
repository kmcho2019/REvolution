module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

wire q_reset;
assign q_reset = ar ? 1'b0 : d;

always @(posedge clk)
    q <= q_reset;

endmodule