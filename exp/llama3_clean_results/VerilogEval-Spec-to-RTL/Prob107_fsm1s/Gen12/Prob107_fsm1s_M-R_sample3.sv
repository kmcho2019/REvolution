module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Using a 1-bit register to represent the state
reg next_state; // Intermediate signal for next state logic

// Combinational logic for next state
assign next_state = (state == 0)? ~in : in;

// Sequential logic for state update
always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
    end else begin
        state <= next_state;
    end
end

// Combinational logic for output
assign out = ~state; // Output is 1 in state B (0) and 0 in state A (1)

endmodule