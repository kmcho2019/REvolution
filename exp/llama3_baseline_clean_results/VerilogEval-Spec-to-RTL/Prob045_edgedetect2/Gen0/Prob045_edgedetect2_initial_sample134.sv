module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;
reg [7:0] anyedge_reg;

always @(posedge clk) begin
    prev_in <= in;
    anyedge_reg <= (prev_in ^ in);
end

assign anyedge = anyedge_reg;

endmodule