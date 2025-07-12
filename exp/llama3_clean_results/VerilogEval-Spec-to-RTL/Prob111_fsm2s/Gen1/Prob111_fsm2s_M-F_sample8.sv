module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Enum for states
enum logic {OFF, ON} state, nextState;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= nextState;
    end
end

// Next state logic
always_comb begin
    case (state)
        OFF: nextState = j ? ON : OFF;
        ON:  nextState = k ? OFF : ON;
        default: nextState = OFF; // Default to OFF for any unspecified state
    endcase
end

// Output logic
assign out = (state == ON);

endmodule