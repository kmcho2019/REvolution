module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input en,          // Enable signal for power optimization
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= {WIDTH{1'b0}};  // Synchronous reset
    end else if (en) begin   // Only update when enabled
        q <= d;
    end
end

endmodule