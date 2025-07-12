module right_shifter (
    input clk,
    input d,
    output reg [7:0] q = 0
);

always @(posedge clk) begin
    q <= {d, q[7:1]};  // Right shift by 1 and insert d at MSB
end

endmodule