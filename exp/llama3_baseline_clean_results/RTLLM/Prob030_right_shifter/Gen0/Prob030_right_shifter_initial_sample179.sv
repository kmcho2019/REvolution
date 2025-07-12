module right_shifter(
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] q;

initial
begin
    q = 8'd0; // Initialize q to 0
end

always @(posedge clk)
begin
    q <= {d, q[7:1]}; // Right shift q and insert d into the most significant bit
end

endmodule