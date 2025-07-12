module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

always @(posedge clk) begin
    anyedge <= in ^ in;
end

endmodule