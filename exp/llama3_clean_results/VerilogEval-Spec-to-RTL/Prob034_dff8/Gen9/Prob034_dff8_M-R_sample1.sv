// TopModule that implements 8 D flip-flops
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q <= d; // Non-blocking assignment for clocked event
end

endmodule