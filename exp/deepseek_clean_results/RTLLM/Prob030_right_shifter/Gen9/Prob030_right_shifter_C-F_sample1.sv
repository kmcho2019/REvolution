module right_shifter (
    input clk,
    input d,
    input enable,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (enable) begin
        q <= {d, q[7:1]};  // Efficient right shift with new bit insertion
    end
end

endmodule