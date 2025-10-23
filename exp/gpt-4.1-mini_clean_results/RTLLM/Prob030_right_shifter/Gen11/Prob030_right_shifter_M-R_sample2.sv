module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

initial q = 8'b0;

always @(posedge clk) begin
    // Explicitly shift right by one bit and assign MSB to d
    q[0] <= q[1];
    q[1] <= q[2];
    q[2] <= q[3];
    q[3] <= q[4];
    q[4] <= q[5];
    q[5] <= q[6];
    q[6] <= q[7];
    q[7] <= d;
end

endmodule