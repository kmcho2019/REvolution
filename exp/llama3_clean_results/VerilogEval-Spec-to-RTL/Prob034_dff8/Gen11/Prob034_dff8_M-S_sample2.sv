// Define the TopModule that includes 8 D flip-flops
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q = 0
);

// Implement 8 D flip-flops using a single always block
always @(posedge clk) begin
    q <= d;
end

endmodule