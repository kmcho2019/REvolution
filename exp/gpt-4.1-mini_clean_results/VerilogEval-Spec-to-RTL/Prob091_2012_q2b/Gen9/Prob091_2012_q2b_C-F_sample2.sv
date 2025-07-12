module NextStateInput(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;
    // States that lead to state D on input w=0: B(y[1]), C(y[2]), E(y[4]), F(y[5])
    wire states_to_D = y[1] | y[2] | y[4] | y[5];

    // Next state input for flip-flop y[1] (state B): only from A(y[0]) when w=1
    assign Y1 = y[0] & w;

    // Next state input for flip-flop y[3] (state D): from states_to_D when w=0
    assign Y3 = states_to_D & w_n;
endmodule

module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    NextStateInput next_state_input (
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );
endmodule