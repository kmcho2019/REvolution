module TopModule(
    input        clk,
    input        areset,
    input        in,
    output       out
);

reg state; // current state (0 for A, 1 for B)
reg next_state; // Next state

// Combinational logic to determine the next state
always @(*) begin
    case(state)
        1'b0: next_state = ~in; // If in state A, move to B on input 0, stay in A on input 1
        1'b1: next_state = in;  // If in state B, move to A on input 0, stay in B on input 1
    endcase
end

// Sequential process to update the current state
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // asynchronously reset into state B
    end else begin
        state <= next_state; // Update state based on next_state logic
    end
end

// Assign output based on the current state
assign out = state;

endmodule