module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,  // Shift enable control
    output reg [7:0] q = 0  // Initialize to 0
);

always @(posedge clk) begin
    if (enable) begin
        q <= {d, q[7:1]};  // Efficient concatenation-based shift
    end
end

endmodule