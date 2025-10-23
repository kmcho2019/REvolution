module right_shifter (
    input  wire       clk,
    input  wire       d,
    output reg  [7:0] q
);

initial q = 8'b0;

always @(posedge clk) begin
    q[0] <= 1'b0;
    q[1] <= q[0];
    q[2] <= q[1];
    q[3] <= q[2];
    q[4] <= q[3];
    q[5] <= q[4];
    q[6] <= q[5];
    q[7] <= d;
end

endmodule