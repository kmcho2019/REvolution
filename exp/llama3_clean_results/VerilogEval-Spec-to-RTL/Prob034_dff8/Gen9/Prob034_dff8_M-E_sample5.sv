// TopModule that implements an 8-bit shift register
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q = 0
);

always @(posedge clk) begin
    q <= {d[7:0]};
end

endmodule