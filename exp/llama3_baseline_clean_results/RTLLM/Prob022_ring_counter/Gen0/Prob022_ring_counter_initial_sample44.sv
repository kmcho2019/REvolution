module ring_counter (
    input clk,  // Clock signal
    input reset,  // Reset signal
    output [7:0] out  // 8-bit output representing the current state
);

reg [7:0] state;  // Register to store the current state

// Initialize the output to match the internal state
assign out = state;

// Always block to handle sequential logic (sensitive to both clock edge and reset)
always @(posedge clk, posedge reset) begin
    if (reset) begin  // If reset is high, reset the counter to its initial state
        state <= 8'b0000_0001;
    end else begin  // On rising edge of the clock, shift the state
        state <= {state[6:0], state[7]};  // Shift left and wrap the MSB to the LSB
    end
end

endmodule