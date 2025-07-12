module right_shifter(
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] q;

initial q = 8'b0; // Initialize q to 0

always @(posedge clk) begin
    q <= {d, q[7:1]}; // Right shift q by 1 bit and insert d into the most significant position
end

endmodule