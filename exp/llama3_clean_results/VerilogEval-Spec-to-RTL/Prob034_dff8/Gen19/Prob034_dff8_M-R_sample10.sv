// Refactored TopModule using 8 individual D flip-flops
module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Generate 8 DFFs
always @(posedge clk) begin
    q <= d;
end

endmodule