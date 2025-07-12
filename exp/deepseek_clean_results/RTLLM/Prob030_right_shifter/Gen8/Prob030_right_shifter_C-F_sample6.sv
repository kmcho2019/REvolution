module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,
    output reg [7:0] q = 0
);

always @(posedge clk) begin
    if (enable) begin
        q <= {d, q[7:1]};  // Efficient right shift with new bit insertion
    end
end

endmodule