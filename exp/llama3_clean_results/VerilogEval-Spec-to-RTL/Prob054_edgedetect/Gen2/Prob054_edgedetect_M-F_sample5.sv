module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;
reg [7:0] internal_pedge;

always @(posedge clk) begin
    prev_in <= in;
    internal_pedge <= in & (~prev_in);
end

assign pedge = internal_pedge;

endmodule