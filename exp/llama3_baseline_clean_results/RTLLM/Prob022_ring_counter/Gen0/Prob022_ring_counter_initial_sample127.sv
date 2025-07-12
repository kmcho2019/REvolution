module ring_counter (
    input clk,  // Clock signal
    input reset,  // Reset signal
    output reg [7:0] out  // 8-bit output
);

// Initialize the output to its starting state when reset is high
always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 8'b0000_0001;  // Reset state: out = 8'b0000_0001
    end else begin
        out <= {out[6:0], out[7]};  // Shift the bits to the right and wrap around
    end
end

endmodule