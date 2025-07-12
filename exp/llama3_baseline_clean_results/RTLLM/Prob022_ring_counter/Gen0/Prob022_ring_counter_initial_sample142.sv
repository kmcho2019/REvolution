module ring_counter (
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;

// Initialize the state to its starting value
initial state = 8'b0000_0001;

// Define the next state
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the state to its initial value
        state <= 8'b0000_0001;
    end else begin
        // Shift the 1 to the next bit in the sequence
        state <= {state[6:0], state[7]};
    end
end

// Assign the state to the output
assign out = state;

endmodule