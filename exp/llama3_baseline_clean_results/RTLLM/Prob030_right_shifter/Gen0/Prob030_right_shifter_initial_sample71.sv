module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q <= {d, q[7:1]};
end

initial begin
    q = 8'b0;
end

endmodule