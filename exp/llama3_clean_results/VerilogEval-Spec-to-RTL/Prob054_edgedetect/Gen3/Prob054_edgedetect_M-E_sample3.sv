module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_value;

always @(posedge clk) begin
    prev_value <= in;
    pedge <= in & ~prev_value;
end

endmodule