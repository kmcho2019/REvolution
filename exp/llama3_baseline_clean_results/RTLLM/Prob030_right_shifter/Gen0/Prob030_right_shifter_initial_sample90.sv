module right_shifter(
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] q;

initial
    q = 8'b0;

always @ (posedge clk)
begin
    q[7] = d;  // assign the most significant bit (q[7]) the value of the input signal (d)
    q[6:0] = q[7:1];  // right shift the contents of the q register by one bit
end

endmodule