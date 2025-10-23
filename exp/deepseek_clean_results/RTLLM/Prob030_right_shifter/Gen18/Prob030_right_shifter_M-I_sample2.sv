module right_shifter #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire d,
    output reg [WIDTH-1:0] q = 0
);

always @(posedge clk) begin
    q <= {d, q[WIDTH-1:1]};  // Right shift with new bit insertion
end

endmodule