module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output [7:0] q
);

always @(posedge clk or posedge areset)
    if (areset) q <= 8'd0;
    else q <= d;

endmodule