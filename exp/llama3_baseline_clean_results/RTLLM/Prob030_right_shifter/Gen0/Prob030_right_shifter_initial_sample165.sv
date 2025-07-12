module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

always @(posedge clk) begin
    q[7] <= d;
    q[6:0] <= q[7:1];
end

initial begin
    q <= 8'd0;
end

endmodule