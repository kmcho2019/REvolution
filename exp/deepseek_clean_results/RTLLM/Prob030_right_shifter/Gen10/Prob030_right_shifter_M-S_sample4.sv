module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q = 0
);

always @(posedge clk) begin
    q <= {d, q[7:1]};  // Right shift and insert new bit in MSB
end

endmodule