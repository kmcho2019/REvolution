module TopModule(
    input  clk,
    input  [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;
reg [7:0] pedge_reg;

always @(posedge clk) begin
    prev_in <= in;
    pedge_reg <= (prev_in == 8'b0) & in;
end

assign pedge = pedge_reg;

endmodule