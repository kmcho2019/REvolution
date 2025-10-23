module TopModule (
    input clk,
    input d,
    output reg q
);

wire clk_posedge;
reg last_clk;

// Detect positive clock edge
assign clk_posedge = clk & ~last_clk;

always @* begin
    last_clk = clk;
    if (clk_posedge) begin
        q = d;
    end
end

endmodule