module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Simple 8-bit positive-edge triggered register
always @(posedge clk) begin
    q <= d;
end

endmodule