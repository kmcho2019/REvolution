module right_shifter (
    input clk,
    input d,
    output reg [7:0] q
);

initial begin
    q = 8'd0; // Initialize q to 0
end

always @(posedge clk) begin
    // Right shift the contents of q by one bit and insert d into the most significant position
    q <= {d, q[7:1]};
end

endmodule