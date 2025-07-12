module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Output logic (only depends on the current state)
    assign out = state[3];  // D state has output 1, all others have output 0

    // Next state logic (depends on current state and input)
    always @(*) begin
        case (state)
            4'b0001:  // State A
                next_state = in ? 4'b0010 : 4'b0001;  // in=1 -> B, in=0 -> A
            4'b0010:  // State B
                next_state = in ? 4'b0010 : 4'b0100;  // in=1 -> B, in=0 -> C
            4'b0100:  // State C
                next_state = in ? 4'b1000 : 4'b0001;  // in=1 -> D, in=0 -> A
            4'b1000:  // State D
                next_state = in ? 4'b0010 : 4'b0100;  // in=1 -> B, in=0 -> C
            default:   // Invalid state
                next_state = 4'b0000;  // Default to an unknown state
        endcase
    end

endmodule