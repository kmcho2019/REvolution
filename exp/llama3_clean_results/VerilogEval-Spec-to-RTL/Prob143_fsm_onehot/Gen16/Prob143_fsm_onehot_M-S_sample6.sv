module TopModule(
    input in,
    input [9:0] state,
    output [9:0] next_state,
    output out1,
    output out2
);

    assign next_state = {
        state[0]? (in? 10'b0 : 10'b1) : 10'b0,
        state[1]? (in? 10'b0 : 10'b0) : 10'b0,
        state[2]? (in? 10'b0 : 10'b0) : 10'b0,
        state[3]? (in? 10'b0 : 10'b0) : 10'b0,
        state[4]? (in? 10'b0 : 10'b0) : 10'b0,
        state[5]? (in? 10'b100000 : 10'b10000000) : 10'b0,
        state[6]? (in? 10'b1000000 : 10'b100000000) : 10'b0,
        state[7]? (in? 10'b1000000 : 10'b1) : 10'b0,
        state[8]? (in? 10'b1 : 10'b1) : 10'b0,
        state[9]? (in? 10'b1 : 10'b1) : 10'b0
    };

    assign out1 = state[8] | state[9];
    assign out2 = state[7] | state[9];

endmodule