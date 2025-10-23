module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;
reg [7:0] anyedge_reg;

always @(posedge clk) begin
    anyedge_reg <= (in ^ prev_in);
    prev_in <= in;
end

assign anyedge = anyedge_reg;

endmodule