module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

reg q_reg;
wire clk_rise;

// Detect positive clock edge
assign clk_rise = clk & ~$past(clk);

always @* begin
    if (ar)
        q_reg = 1'b0;
    else if (clk_rise)
        q_reg = d;
end

assign q = q_reg;

endmodule