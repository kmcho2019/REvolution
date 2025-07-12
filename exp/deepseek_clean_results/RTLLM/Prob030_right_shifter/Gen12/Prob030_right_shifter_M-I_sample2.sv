module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q = 8'b0  // Initialization with default value
);

always @(posedge clk) begin
    q <= {d, q[7:1]};  // Efficient single-cycle shift operation
end

endmodule