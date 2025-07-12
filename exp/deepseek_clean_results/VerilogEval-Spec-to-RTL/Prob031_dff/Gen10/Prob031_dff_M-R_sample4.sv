module TopModule (
    input clk,
    input d,
    output reg q
);

wire clk_posedge;
reg last_clk;

assign clk_posedge = clk & ~last_clk;

always @* begin
    if (clk_posedge) q = d;
    last_clk = clk;
end

endmodule