module right_shifter (
    input wire clk,    // Clock signal for synchronous operation
    input wire d,      // Input bit to be shifted in
    output reg [7:0] q // 8-bit shift register output
);

// Initialize shift register to all zeros
initial begin
    q = 8'b0;
end

// Right shift operation:
// On each rising clock edge:
// 1. Shift all bits right by one position (q[6:0] -> q[7:1])
// 2. Insert new input bit 'd' at the MSB (q[7])
// Note: The LSB (q[0]) is discarded in this operation
always @(posedge clk) begin
    q <= {d, q[7:1]};
end

endmodule