module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

initial begin
    q = 8'b0;  // Initialize register to 0
end

always @(posedge clk) begin
    q <= {d, q[7:1]};  // Right shift with new MSB
end

endmodule