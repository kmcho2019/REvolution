module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

reg [WIDTH-1:0] q_reg;

assign q = q_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= {WIDTH{1'b0}};  // Reset all bits to 0
    end else begin
        q_reg <= d;  // Normal operation
    end
end

endmodule