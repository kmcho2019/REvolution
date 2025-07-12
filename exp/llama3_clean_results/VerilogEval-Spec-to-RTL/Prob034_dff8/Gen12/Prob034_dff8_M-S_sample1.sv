// Simplified TopModule implementation
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q <= d; // Directly assign d to q
end

endmodule