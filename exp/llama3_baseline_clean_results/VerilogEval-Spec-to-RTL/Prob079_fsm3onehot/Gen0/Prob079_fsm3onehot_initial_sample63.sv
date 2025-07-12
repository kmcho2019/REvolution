module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

// Next state logic
always @(state, in) begin
    case (state)
        4'b0001: next_state = in ? 4'b0010 : 4'b0001;  // State A
        4'b0010: next_state = in ? 4'b0010 : 4'b0100;  // State B
        4'b0100: next_state = in ? 4'b1000 : 4'b0001;  // State C
        4'b1000: next_state = in ? 4'b0010 : 4'b0100;  // State D
        default: next_state = 4'b0000;  // Invalid state
    endcase
end

// Output logic
always @(state) begin
    case (state)
        4'b0001: out = 0;  // State A
        4'b0010: out = 0;  // State B
        4'b0100: out = 0;  // State C
        4'b1000: out = 1;  // State D
        default: out = 0;  // Invalid state
    endcase
end

endmodule