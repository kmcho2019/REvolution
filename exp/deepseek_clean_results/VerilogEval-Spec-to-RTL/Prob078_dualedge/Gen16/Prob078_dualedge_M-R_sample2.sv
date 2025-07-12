module TopModule (
    input clk,
    input d,
    output q
);

reg last_clk;
reg posedge_reg;
reg negedge_reg;

wire posedge_detect = clk & ~last_clk;
wire negedge_detect = ~clk & last_clk;

always @(*) begin
    last_clk <= clk;
    posedge_reg <= posedge_detect ? d : posedge_reg;
    negedge_reg <= negedge_detect ? d : negedge_reg;
end

assign q = clk ? posedge_reg : negedge_reg;

endmodule