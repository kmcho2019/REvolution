module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] in_prev;

always @(posedge clk) begin
    in_prev <= in;
end

assign pedge = (in & (~in_prev));

endmodule