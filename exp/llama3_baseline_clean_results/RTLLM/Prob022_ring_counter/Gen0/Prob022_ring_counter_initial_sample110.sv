module ring_counter(
    input  clk,       // Clock signal
    input  reset,      // Reset signal
    output reg [7:0] out // 8-bit output representing the current state
);

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize the counter to its starting state when reset is high
        out <= 8'b0000_0001;
    end else begin
        // Shift the current state one bit to the left
        out <= {out[6:0], out[7]};
    end
end

endmodule