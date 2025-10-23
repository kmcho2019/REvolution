module TopModule(
    input clk,
    input d,
    output q
);

reg clk_x2;
always @(posedge clk or negedge clk) begin
    // This sensitivity list is still not allowed in standard Verilog.
    // Instead, use the following alternative implementation.
end

// Alternative implementation for creating a double frequency clock
reg clk_x2_reg;
initial clk_x2_reg = 1'b0;
always @(posedge clk or negedge clk) begin
    clk_x2_reg <= ~clk_x2_reg;
end
assign clk_x2 = clk_x2_reg;

reg q_reg_simplified;
always @(posedge clk_x2) begin
    q_reg_simplified <= d;
end

assign q = q_reg_simplified;

endmodule