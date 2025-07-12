module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // Output is 1 only in state D (2'b11)
    assign out = state[1] & state[0];

    // Next state logic simplified:
    // next_state[1] = 1 if (state==B and in=0) or (state==D and in=0) or (state==C and in=1)
    // next_state[0] = 1 if (state==A and in=1) or (state==B and in=1) or (state==D and in=1)

    assign next_state[1] = (state == 2'b01 && ~in) | (state == 2'b11 && ~in) | (state == 2'b10 && in);
    assign next_state[0] = (state == 2'b00 && in) | (state == 2'b01 && in) | (state == 2'b11 && in);

endmodule