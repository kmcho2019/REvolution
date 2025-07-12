module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] in_reg;
reg [31:0] out_reg;

always @(posedge clk) begin
    if (reset) begin
        in_reg <= 32'd0;
        out_reg <= 32'd0;
    end else begin
        in_reg <= in;
        out_reg <= out_reg | (~in & in_reg);
    end
end

assign out = out_reg;

endmodule