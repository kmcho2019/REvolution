module ring_counter(
    input clk,       // Clock signal
    input reset,     // Reset signal
    output [7:0] out  // 8-bit output
);

reg [7:0] state;     // Register to store the current state

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset to initial state with LSB set to 1
        state <= 8'b0000_0001;
    end else begin
        // Shift the current state one bit to the left and wrap around to LSB
        state <= {state[6:0], state[7]};
    end
end

assign out = state; // Assign the current state to the output

endmodule