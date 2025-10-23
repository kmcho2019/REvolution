module TopModule(
    input wire clk,
    input wire in,
    output wire out
);

reg pipeline_reg;

always @(posedge clk) begin
    pipeline_reg <= in;
end

assign out = pipeline_reg;

endmodule