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
    q[7:1] <= q[6:0]; // Right shift q by 1 bit
    q[0] <= 1'b0; // Fill the least significant bit with 0
    q[7] <= d; // Assign d to the most significant bit
end

endmodule