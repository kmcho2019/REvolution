module right_shifter(
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] q;

initial
    q = 8'b0;

always @(posedge clk)
begin
    q[7:1] = q[6:0]; // shift q to the right by one bit
    q[0] = 1'b0; // clear the least significant bit
    q[7] = d; // insert the new input bit into the most significant position
end

endmodule