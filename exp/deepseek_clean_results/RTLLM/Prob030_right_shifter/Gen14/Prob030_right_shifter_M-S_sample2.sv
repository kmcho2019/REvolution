module right_shifter (
    input clk,
    input d,
    output reg [7:0] q = 0
);

always @(posedge clk) begin
    q <= {d, q[7:1]};  // Direct right shift with new MSB insertion
end

endmodule