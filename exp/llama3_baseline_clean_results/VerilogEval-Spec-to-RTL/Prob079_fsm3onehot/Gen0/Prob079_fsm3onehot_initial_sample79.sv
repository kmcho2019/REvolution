module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic: Out is 1 only when in state D, which is 4'b1000
    assign out = state[3]; // Since D is encoded as 1000, out is 1 only when state[3] is 1

    // Next state logic
    always @(*) begin
        casez (state)
            4'b0001: // State A
                next_state = in ? 4'b0010 : 4'b0001; // in=1 -> B, in=0 -> A
            4'b0010: // State B
                next_state = in ? 4'b0010 : 4'b0100; // in=1 -> B, in=0 -> C
            4'b0100: // State C
                next_state = in ? 4'b1000 : 4'b0001; // in=1 -> D, in=0 -> A
            4'b1000: // State D
                next_state = in ? 4'b0010 : 4'b0100; // in=1 -> B, in=0 -> C
            default:
                next_state = 4'bxxxx; // Invalid state, next state is undefined
        endcase
    end

endmodule