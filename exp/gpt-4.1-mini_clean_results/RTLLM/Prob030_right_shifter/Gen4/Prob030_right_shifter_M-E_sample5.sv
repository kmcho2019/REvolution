module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

initial q = 8'b0;

integer i;

always @(posedge clk) begin
    for (i = 0; i < 7; i = i + 1) begin
        q[i] <= q[i+1];
    end
    q[7] <= d;
end

endmodule