module right_shifter #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire d,
    input wire enable,  // Optional clock enable
    output reg [WIDTH-1:0] q = 0
);

always @(posedge clk) begin
    if (enable) begin
        q <= {d, q[WIDTH-1:1]};  // Efficient right shift with new MSB
    end
end

endmodule