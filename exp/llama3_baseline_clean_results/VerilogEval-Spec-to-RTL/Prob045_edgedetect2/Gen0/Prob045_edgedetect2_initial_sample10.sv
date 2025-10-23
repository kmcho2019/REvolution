module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;
reg [7:0] anyedge_reg;

initial begin
    prev_in = 0;
    anyedge_reg = 0;
end

always @(posedge clk) begin
    anyedge_reg <= (in ^ prev_in);  // detect edge
    prev_in <= in;  // update previous input
end

always @(*) begin
    anyedge = anyedge_reg;
end

endmodule