module LFSR(
    input clk, // Clock signal
    input rst, // Active high reset signal
    output reg [3:0] out // 4-bit output representing the current state of the LFSR
);

// Internal state register
reg [3:0] state;

// Update the LFSR state on the rising edge of the clock or reset
always @ (posedge clk or posedge rst) begin
    if (rst) begin // Reset the LFSR to zero
        state <= 4'b0;
        out <= 4'b0; // Explicitly reset output
    end else begin // Shift the bits left and insert the new feedback value
        // Calculate the feedback as the inverted XOR of the most significant bit and the second most significant bit
        reg feedback;
        feedback = ~(state[3] ^ state[2]);
        
        // Shift the bits left and insert the feedback at the least significant bit
        state <= {state[2:0], feedback};
        out <= state; // Update the output with the new state
    end
end

endmodule