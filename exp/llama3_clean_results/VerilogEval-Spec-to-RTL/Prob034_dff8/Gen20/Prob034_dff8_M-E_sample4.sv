// Parameterized TopModule using D flip-flops
module TopModule #(
    parameter WIDTH = 8
)(
    input clk,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

// Generate DFFs and connect them in parallel
always @(posedge clk) begin
    q <= d;
end

endmodule