module TopModule(
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output       out
);
    // State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

    always @(*) begin
        case (state)
            4'b0001: // State A
                next_state = in ? 4'b0010 : 4'b0001; // A->B if in=1 else A
            4'b0010: // State B
                next_state = in ? 4'b0010 : 4'b0100; // B->B if in=1 else C
            4'b0100: // State C
                next_state = in ? 4'b1000 : 4'b0001; // C->D if in=1 else A
            4'b1000: // State D
                next_state = in ? 4'b0010 : 4'b0100; // D->B if in=1 else C
            default:
                next_state = 4'b0000; // undefined state, no next state
        endcase
    end

    // Output logic: output=1 only in state D
    assign out = state[3];

endmodule