module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q <= {d, q[7:1]};  // Simple right shift with new bit insertion
end

endmodule