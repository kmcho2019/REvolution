module right_shifter (
    input clk,
    input d,
    output reg [7:0] q
);

initial begin
    q = 8'b0;  // Initialize register to 0
end

always @(posedge clk) begin
    q <= {d, q[7:1]};  // Right shift and insert new bit
end

endmodule