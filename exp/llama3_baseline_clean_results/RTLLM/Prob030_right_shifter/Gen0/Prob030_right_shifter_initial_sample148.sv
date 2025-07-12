module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

initial q = 8'b0; // Initialize q to 0

always @(posedge clk) begin
    // Shift q to the right by 1 bit and insert d into the most significant position
    q <= {d, q[7:1]};
end

endmodule