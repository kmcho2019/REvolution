module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output [3:0] out // 4-bit output representing the current state of the LFSR
);

reg [3:0] state; // Current state of the LFSR

// Update the LFSR state on the rising edge of the clock or reset
always @ (posedge clk or posedge rst) begin
    if (rst) begin // Reset the LFSR to zero
        state <= 4'b0;
    end else begin // Shift the bits left and insert the new feedback value
        state <= {state[2:0], ~(state[3] ^ state[2])}; // Calculate and assign the new state
    end
end

// Directly assign the state to the output
assign out = state;

endmodule