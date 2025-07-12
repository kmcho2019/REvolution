module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// Define states
enum logic [0:0] {OFF, ON} state, nextState;

// Combinational logic for next state
always_comb begin
    case(state)
        OFF: nextState = (j == 1'b1) ? ON : OFF;
        ON:  nextState = (k == 1'b1) ? OFF : ON;
        default: nextState = OFF; // default to OFF
    endcase
end

// Clocked logic for state update
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;
    end else begin
        state <= nextState;
    end
end

// Output logic
assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule