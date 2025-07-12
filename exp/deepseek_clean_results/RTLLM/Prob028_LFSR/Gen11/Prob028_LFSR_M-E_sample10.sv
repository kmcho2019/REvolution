module LFSR (
    input wire clk,        // Clock input
    input wire rst,        // Active-high synchronous reset
    output reg [3:0] out  // Current LFSR state
);

// Feedback Lookup Table (LUT)
// Each 4-bit state maps to a 1-bit feedback value
reg [15:0] feedback_LUT;

initial begin
    // Initialize LUT with custom feedback pattern
    // This example uses a modified maximal-length sequence
    feedback_LUT = 16'b0101101010101010;
end

// Sequential state update
always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;    // Initialize to non-zero state
    end else begin
        // Shift left and insert LUT-based feedback at LSB
        out <= {out[2:0], feedback_LUT[out]};
    end
end

endmodule