module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_state;
reg [7:0] anyedge_reg;

always @(posedge clk) begin
    prev_state <= in;
    anyedge_reg <= (in ^ prev_state);
end

assign anyedge = anyedge_reg;

endmodule