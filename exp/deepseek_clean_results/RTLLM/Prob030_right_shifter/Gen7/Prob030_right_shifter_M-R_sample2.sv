module right_shifter (
    input clk,
    input d,
    output reg [7:0] q = 8'b0  // Initialization in declaration
);

always @(posedge clk) begin
    q <= {d, q[7:1]};  // Concatenate new bit with upper 7 bits
end

endmodule