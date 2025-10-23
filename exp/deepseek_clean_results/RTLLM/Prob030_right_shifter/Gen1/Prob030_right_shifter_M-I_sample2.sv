module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q = 0  // Initialize with default value
);

always @(posedge clk) begin
    q <= {d, q[7:1]};
end

endmodule