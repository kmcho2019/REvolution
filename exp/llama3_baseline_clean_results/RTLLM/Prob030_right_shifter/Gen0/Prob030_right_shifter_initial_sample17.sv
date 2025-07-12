module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

initial
    q = 8'b0;

always @ (posedge clk)
begin
    q[7] = d;
    q[6:0] = q[7:1];
end

endmodule