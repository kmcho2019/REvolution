module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q = 0
);

always @(posedge clk) begin
    q <= {d, q[7:1]};  // Shift right and insert new bit
end

endmodule