module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state of the LFSR
);

// Internal signal to calculate the feedback
reg feedback;

always @ (posedge clk) begin
    if (rst) begin
        // Reset the LFSR to zero when the reset signal is high
        out <= 4'd0;
    end else begin
        // Calculate the feedback signal by XORing the most significant bit and the second most significant bit
        feedback = ~(out[3] ^ out[2]);
        
        // Shift the bits left and insert the new feedback value at the LSB
        out <= {out[2:0], feedback};
    end
end

endmodule