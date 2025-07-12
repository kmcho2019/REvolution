module ring_counter(
    input clk,      // Clock signal
    input reset,    // Reset signal
    output [7:0] out // 8-bit output representing the current state
);

reg [7:0] state;    // Register to store the current state

// Initialize the state to the least significant bit set to 1 when reset is high
always @(posedge reset or posedge clk) begin
    if(reset) begin
        state <= 8'b0000_0001; // Reset state
    end else begin
        // Shift the state to the next bit in the sequence
        state <= {state[6:0], state[7]}; 
    end
end

// Assign the current state to the output
assign out = state;

endmodule