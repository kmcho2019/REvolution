module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg state; // 1-bit signal to represent the state

// Directly assign next state logic
assign out = state; // Output is the same as the state

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Asynchronously reset to state B
    end else begin
        case(state)
            1'b0: state <= in? 1'b0 : 1'b1; // State A transitions
            1'b1: state <= in? 1'b1 : 1'b0; // State B transitions
        endcase
    end
end

endmodule