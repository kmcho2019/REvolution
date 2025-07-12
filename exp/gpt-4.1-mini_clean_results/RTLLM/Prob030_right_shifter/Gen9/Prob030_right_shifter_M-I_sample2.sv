module right_shifter (
    input clk,
    input d,
    output reg [7:0] q
);

initial q = 8'b0;

always @(posedge clk) begin
    // Update only if input d or q is nonzero to reduce toggling
    if (d || q != 8'b0) begin
        q <= {d, q[7:1]};
    end
end

endmodule