module right_shifter(
    input clk,
    input d,
    output reg [7:0] q
);

initial q = 8'd0; // Initialize q to 0

always @ (posedge clk) begin
    // Shift the contents of q to the right by one bit
    q <= {d, q[7:1]};
end

endmodule