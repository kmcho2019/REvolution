module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output       out
);

    // One-hot encoding:
    // A = 4'b0001 (state[0])
    // B = 4'b0010 (state[1])
    // C = 4'b0100 (state[2])
    // D = 4'b1000 (state[3])

    always @(*) begin
        case (1'b1) // check which bit in state is set
            state[0]: // A
                next_state = in ? 4'b0010 : 4'b0001; // B if in=1 else A
            state[1]: // B
                next_state = in ? 4'b0010 : 4'b0100; // B if in=1 else C
            state[2]: // C
                next_state = in ? 4'b1000 : 4'b0001; // D if in=1 else A
            state[3]: // D
                next_state = in ? 4'b0010 : 4'b0100; // B if in=1 else C
            default:
                next_state = 4'b0000; // invalid or reset state
        endcase
    end

    // Output is 1 only if in state D (state[3])
    assign out = state[3];

endmodule