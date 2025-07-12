module TopModule(
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output reg out
);

// Next state logic equations
always @(*) begin
    case(state)
        4'b0001: // State A
            if (~in) next_state = 4'b0001; // Stay in A
            else next_state = 4'b0010; // Go to B
        4'b0010: // State B
            if (~in) next_state = 4'b0100; // Go to C
            else next_state = 4'b0010; // Stay in B
        4'b0100: // State C
            if (~in) next_state = 4'b0001; // Go to A
            else next_state = 4'b1000; // Go to D
        4'b1000: // State D
            if (~in) next_state = 4'b0100; // Go to C
            else next_state = 4'b0010; // Go to B
        default: next_state = 4'b0001; // Go to A by default
    endcase
end

// Output logic equation
always @(*) begin
    if (state == 4'b1000) out = 1'b1; // Output 1 when in state D
    else out = 1'b0; // Output 0 otherwise
end

endmodule