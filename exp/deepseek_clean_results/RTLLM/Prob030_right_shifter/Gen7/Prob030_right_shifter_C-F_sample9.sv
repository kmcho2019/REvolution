module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,  // Data gating control
    output reg [7:0] q
);

always @(posedge clk) begin
    if (enable) begin
        q <= {d, q[7:1]};  // Efficient concatenation-based shift
    end
    // else hold current value (implicit)
end

endmodule