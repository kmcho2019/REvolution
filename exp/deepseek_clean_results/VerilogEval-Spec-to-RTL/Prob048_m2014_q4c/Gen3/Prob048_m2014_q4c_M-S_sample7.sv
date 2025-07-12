module TopModule (
    input clk, d, r,
    output reg q
);

always @(posedge clk) q <= r ? 1'b0 : d;

endmodule