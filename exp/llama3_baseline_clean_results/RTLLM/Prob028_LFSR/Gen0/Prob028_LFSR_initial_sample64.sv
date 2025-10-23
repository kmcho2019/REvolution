module LFSR(
    input clk,
    input rst,
    output reg [3:0] out
);

// Calculate the feedback signal by XORing the most significant bit and the second most significant bit, then inverting the result
wire feedback = ~(out[3] ^ out[2]);

// Use a clocked always block to synchronize the shifting operation
always @(posedge clk) begin
    // Implement the reset logic
    if (rst) begin
        // Reset the register to zero if the reset signal is high
        out <= 4'b0000;
    end else begin
        // Shift the bits left and insert the new feedback value at the least significant bit (LSB)
        out <= {out[2:0], feedback};
    end
end

endmodule