module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q <= d; // Update q directly with the input d on each positive clock edge
end

endmodule