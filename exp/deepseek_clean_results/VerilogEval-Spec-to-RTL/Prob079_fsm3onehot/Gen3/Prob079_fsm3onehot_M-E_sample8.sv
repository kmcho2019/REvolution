module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Next state logic implemented with multiplexers
    assign next_state[0] = (state == 4'b0001 & ~in) | (state == 4'b0100 & ~in);
    assign next_state[1] = (state == 4'b0001 & in) | (state == 4'b0010 & in) | (state == 4'b1000 & in);
    assign next_state[2] = (state == 4'b0010 & ~in) | (state == 4'b1000 & ~in);
    assign next_state[3] = (state == 4'b0100 & in);

    // Output logic remains the same
    assign out = state[3];

endmodule