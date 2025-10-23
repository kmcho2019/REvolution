module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] previous_state;
reg [7:0] anyedge_reg;

always @(posedge clk) begin
    previous_state <= in;
    anyedge_reg <= (in ^ previous_state);
end

assign anyedge = anyedge_reg;

endmodule