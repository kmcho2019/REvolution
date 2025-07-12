module ring_counter(
    input clk, 
    input reset, 
    output reg [7:0] out
);

// Internal signal for the ring counter's state
reg [7:0] state;

// Assign the internal state to the output
assign out = state;

// Initial state when reset is high
initial state = 8'b0000_0001;

// Always block to update the state on the rising edge of the clock
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset the counter to its initial state
        state <= 8'b0000_0001;
    end else begin
        // Shift the state one bit to the right
        state <= {state[6:0], state[7]};
    end
end

endmodule