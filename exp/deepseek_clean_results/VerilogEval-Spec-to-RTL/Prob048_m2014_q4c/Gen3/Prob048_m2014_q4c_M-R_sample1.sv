module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

wire next_q = r ? 1'b0 : d;

always @(posedge clk)
    q <= next_q;

endmodule