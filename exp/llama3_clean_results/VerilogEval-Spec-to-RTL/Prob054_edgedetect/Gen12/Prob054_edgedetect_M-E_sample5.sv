module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] curr;
reg [7:0] prev;

always @(posedge clk) begin
    prev <= curr;
    curr <= in;
end

assign pedge = (in & ~prev);

endmodule