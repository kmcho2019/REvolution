module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    assign out = (state[3] == 1'b1); // Output is 1 only when in state D

    always @(*) begin
        case(state)
            4'b0001: // State A
                next_state = (in == 1'b0) ? 4'b0001 : 4'b0010; // Next state is A if in=0, B if in=1
            4'b0010: // State B
                next_state = (in == 1'b0) ? 4'b0100 : 4'b0010; // Next state is C if in=0, B if in=1
            4'b0100: // State C
                next_state = (in == 1'b0) ? 4'b0001 : 4'b1000; // Next state is A if in=0, D if in=1
            4'b1000: // State D
                next_state = (in == 1'b0) ? 4'b0100 : 4'b0010; // Next state is C if in=0, B if in=1
            default:
                next_state = 4'b0000; // Default next state
        endcase
    end

endmodule