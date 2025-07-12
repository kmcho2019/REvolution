// Modular LFSR module with explicit initialization and feedback logic
module LFSR(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the LFSR
);

// Combinational logic block to calculate the feedback
wire feedback;
// Calculate the feedback by XORing the most significant bit (out[3]) and the second most significant bit (out[2]), then inverting the result
assign feedback = ~(out[3] ^ out[2]);

// Sequential logic block to update the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset condition: initialize output to zero
        // Ensure the LFSR is reset to a known state (all zeros) when rst is high
        out <= 4'b0;
    end else begin // Normal operation: update LFSR state
        // Shift the bits in the LFSR and insert the new feedback value at the LSB
        // The expression {out[2:0], feedback} shifts the current bits 2, 1, and 0 to the left and inserts the feedback at bit 0
        out <= {out[2:0], feedback};
    end
end

endmodule