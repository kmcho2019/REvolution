module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q <= d;  // Vector assignment for all 8 bits
end

endmodule