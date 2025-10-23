// Refactored LFSR module with improved structure and readability
module LFSR(
    input           clk,       // Clock signal
    input           rst,       // Active high reset signal
    output reg [3:0] out       // 4-bit output representing the current state of the LFSR
);

// Combinational logic for feedback calculation
wire feedback;
assign feedback = ~(out[3] ^ out[2]); // Inversion of XOR of most significant and second most significant bits

// Sequential logic block to update the LFSR state
always @(posedge clk or posedge rst) begin
    if (rst) begin // Reset condition: initialize output to zero
        out <= 4'b0;
    end else begin // Normal operation: shift left and insert feedback
        out <= {out[2:0], feedback}; // Shift left and insert feedback at the LSB
    end
end

endmodule