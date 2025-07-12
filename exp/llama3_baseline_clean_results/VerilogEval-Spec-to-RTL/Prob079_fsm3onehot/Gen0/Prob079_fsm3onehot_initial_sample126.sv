module TopModule(
    input  in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// State transition logic
always @(*) begin
    case(state)
        4'b0001: next_state = (in == 0) ? 4'b0001 : 4'b0010; // State A
        4'b0010: next_state = (in == 0) ? 4'b0100 : 4'b0010; // State B
        4'b0100: next_state = (in == 0) ? 4'b0001 : 4'b1000; // State C
        4'b1000: next_state = (in == 0) ? 4'b0100 : 4'b0010; // State D
        default: next_state = 4'b0000; // Invalid state
    endcase
end

// Output logic
always @(*) begin
    case(state)
        4'b0001: out = 0; // State A
        4'b0010: out = 0; // State B
        4'b0100: out = 0; // State C
        4'b1000: out = 1; // State D
        default: out = 0; // Invalid state
    endcase
end

endmodule