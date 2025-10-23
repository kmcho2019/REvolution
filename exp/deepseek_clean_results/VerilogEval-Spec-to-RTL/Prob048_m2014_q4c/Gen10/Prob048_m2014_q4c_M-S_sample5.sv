module TopModule (
    input clk,
    input d,
    input r,
    output q
);

always @(posedge clk) q <= r ? 0 : d;

endmodule