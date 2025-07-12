module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

always @(posedge clk) begin
    // Shift the contents of q to the right by one bit
    q <= {d, q[7:1]};
end

// Initialize the q register to 0
initial begin
    q <= 8'b0;
end

endmodule