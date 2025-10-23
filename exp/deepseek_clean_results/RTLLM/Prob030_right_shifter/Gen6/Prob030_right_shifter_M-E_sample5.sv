module right_shifter #(
    parameter WIDTH = 8
) (
    input clk,
    input d,
    output reg [WIDTH-1:0] q = 0
);

always @(posedge clk) begin
    q <= {d, q[WIDTH-1:1]};  // Concatenate input with upper bits of q
end

endmodule