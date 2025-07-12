module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q = 8'b0  // Initialize to 0
);

always @(posedge clk) begin
    q <= d;  // Standard positive edge-triggered behavior
end

endmodule