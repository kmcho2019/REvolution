module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// Define states
parameter STATE_A = 1'b0;
parameter STATE_B = 1'b1;

reg state; // Current state

// Combinational logic for output z
assign z = (state == STATE_B) ? ~x : x;

// Sequential logic for state machine
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= STATE_A; // Reset to state A
    end else if(state == STATE_A && x) begin
        state <= STATE_B; // Transition to state B if x is high in state A
    end
end

endmodule