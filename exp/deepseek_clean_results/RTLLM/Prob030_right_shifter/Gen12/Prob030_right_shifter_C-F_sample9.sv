module right_shifter #(
    parameter WIDTH = 8
) (
    input clk,
    input d,
    input en,        // Optional enable signal
    output reg [WIDTH-1:0] q = 0
);

always @(posedge clk) begin
    if (en) begin
        q <= {d, q[WIDTH-1:1]};  // Efficient concatenation-based shift
    end
end

endmodule