module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev;

always @(posedge clk) begin
    prev <= in;
end

assign pedge = in & ~prev;

endmodule