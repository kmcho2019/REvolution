module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

wire load_enable;
assign load_enable = reset | (d != q);

always @(posedge clk)
    if (load_enable)
        q <= reset ? 8'b0 : d;

endmodule