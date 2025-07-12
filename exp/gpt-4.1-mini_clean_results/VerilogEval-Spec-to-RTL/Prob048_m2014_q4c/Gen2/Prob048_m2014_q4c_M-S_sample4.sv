module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk)
    if (r)
        q <= 1'b0;
    else
        q <= d;

endmodule