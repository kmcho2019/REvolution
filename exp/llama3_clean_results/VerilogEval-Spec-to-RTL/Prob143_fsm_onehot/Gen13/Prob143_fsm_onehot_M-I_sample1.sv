module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    wire [9:0] next_state_reg;
    wire out1_reg;
    wire out2_reg;

    assign next_state_reg = (
        (state[0] && !in) ? 10'b1 :
        (state[0] && in)  ? 10'b10 :
        (state[1] && !in) ? 10'b1 :
        (state[1] && in)  ? 10'b100 :
        (state[2] && !in) ? 10'b1 :
        (state[2] && in)  ? 10'b1000 :
        (state[3] && !in) ? 10'b1 :
        (state[3] && in)  ? 10'b10000 :
        (state[4] && !in) ? 10'b1 :
        (state[4] && in)  ? 10'b100000 :
        (state[5] && !in) ? 10'b1000000000 :
        (state[5] && in)  ? 10'b1000000 :
        (state[6] && !in) ? 10'b10000000000 :
        (state[6] && in)  ? 10'b10000000 :
        (state[7] && !in) ? 10'b1 :
        (state[7] && in)  ? 10'b10000000 :
        (state[8] && !in) ? 10'b1 :
        (state[8] && in)  ? 10'b10 :
        (state[9] && !in) ? 10'b1 :
        (state[9] && in)  ? 10'b10 :
        10'b0
    );

    assign out1_reg = (state[8] || state[9]);
    assign out2_reg = state[7] || state[9];

    assign next_state = next_state_reg;
    assign out1 = out1_reg;
    assign out2 = out2_reg;

endmodule