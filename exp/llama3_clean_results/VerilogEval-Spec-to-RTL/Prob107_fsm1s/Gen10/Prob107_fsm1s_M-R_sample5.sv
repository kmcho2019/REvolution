module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg state; // Using a 1-bit register to represent the state

// Combinational logic for next state
wire next_state;
assign next_state = (state == 0 && in == 0)? 1 : (state == 1 && in == 0)? 0 : state;

// Combinational logic for output
assign out = ~state; // Output is 1 in state B (0) and 0 in state A (1)

// Sequential logic for state update
always @(posedge clk) begin
    if(reset) begin
        state <= 0; // Reset state is B, represented by binary '0'
    end else begin
        state <= next_state;
    end
end

endmodule