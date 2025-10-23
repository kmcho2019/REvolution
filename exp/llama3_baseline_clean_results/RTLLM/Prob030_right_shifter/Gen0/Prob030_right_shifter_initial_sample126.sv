module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

initial q = 8'b0;

always @ (posedge clk)
begin
    q <= {d, q[7:1]}; // Right shift 'q' by one bit and insert 'd' at the most significant position
end

endmodule