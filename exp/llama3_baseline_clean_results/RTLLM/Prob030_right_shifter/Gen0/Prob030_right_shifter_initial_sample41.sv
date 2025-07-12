module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

initial
    q = 8'b0; // Initialize q to 0

always @(posedge clk)
begin
    q[7] = d; // Assign the most significant bit of q the value of d
    q[6:0] = q[7:1]; // Shift the contents of q to the right by one bit
end

endmodule