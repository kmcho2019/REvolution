module right_shifter #(
    parameter WIDTH = 8
) (
    input clk,
    input d,
    output reg [WIDTH-1:0] q = 0
);

always @(posedge clk) begin
    q <= {d, q[WIDTH-1:1]};  // Right shift with MSB insertion
end

endmodule