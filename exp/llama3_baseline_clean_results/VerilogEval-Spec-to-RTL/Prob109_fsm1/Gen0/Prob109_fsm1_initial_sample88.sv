module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg state; // Variable to keep track of the current state
reg next_state; // Variable to determine the next state

always @(*) begin
    case(state)
        1'b0: next_state = (in) ? 1'b0 : 1'b1; // If current state is A
        1'b1: next_state = (in) ? 1'b1 : 1'b0; // If current state is B
        default: next_state = 1'b1; // Default next state
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // Asynchronously reset to state B
    end else begin
        state <= next_state; // Update the current state
    end
end

assign out = state; // Output is the current state

endmodule