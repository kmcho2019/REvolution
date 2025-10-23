module right_shifter (
    input clk,
    input d,
    output reg [7:0] q = 8'b0  // Initialization with default value
);

always @(posedge clk) begin
    q <= {d, q[7:1]};  // Combined shift and insert operation
end

endmodule