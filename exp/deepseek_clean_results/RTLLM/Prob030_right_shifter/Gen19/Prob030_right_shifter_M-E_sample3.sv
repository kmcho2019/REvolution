module right_shifter (
    input wire clk,
    input wire d,
    output reg [7:0] q
);

initial begin
    q = 8'b0;  // Initialize register to 0
end

always @(posedge clk) begin
    // Perform right shift by concatenating new bit with upper 7 bits
    q <= {d, q[7:1]};
end

endmodule