module ring_counter(
    input clk,         // Clock signal
    input reset,       // Reset signal
    output reg [7:0] out // 8-bit output representing the current state
);

// Internal logic to handle the state transition on the rising edge of the clock
always @(posedge clk, posedge reset) begin
    if (reset) begin
        // Reset the counter to its initial state when reset is high
        out <= 8'b0000_0001;
    end else begin
        // Update the state by shifting the bits to the right and wrapping around
        out <= {out[6:0], out[7]};
    end
end

endmodule