module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

// Positive edge-triggered flip-flops with synchronous reset
always @(posedge clk) begin
    q <= d;
end

endmodule