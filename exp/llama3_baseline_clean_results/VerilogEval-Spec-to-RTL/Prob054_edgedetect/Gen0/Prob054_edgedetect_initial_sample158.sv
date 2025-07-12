module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_state;
reg [7:0] pedge_reg;

always @ (posedge clk) begin
    pedge_reg <= (in & (~prev_state));
    prev_state <= in;
end

assign pedge = pedge_reg;

endmodule