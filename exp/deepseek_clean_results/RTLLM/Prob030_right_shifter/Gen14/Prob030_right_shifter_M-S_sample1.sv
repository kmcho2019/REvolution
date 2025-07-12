module right_shifter (
    input clk,
    input d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q <= {d, q[7:1]};  // Right shift and insert new bit in MSB
end

endmodule