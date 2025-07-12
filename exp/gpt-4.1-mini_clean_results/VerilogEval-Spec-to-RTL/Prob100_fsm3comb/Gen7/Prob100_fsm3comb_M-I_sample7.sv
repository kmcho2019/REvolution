module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    wire s1 = state[1];
    wire s0 = state[0];

    // Output is 1 only when state = 2'b11 (D)
    assign out = s1 & s0;

    // From the state transition table:
    // next_state[1] for in=0: A=0,B=1,C=0,D=1 => next_state[1]_0 = s0 & (~s1)
    // next_state[1] for in=1: A=0,B=0,C=1,D=0 => next_state[1]_1 = s1 & (~s0)
    wire next_state_1_0 = s0 & (~s1);
    wire next_state_1_1 = s1 & (~s0);
    assign next_state[1] = in ? next_state_1_1 : next_state_1_0;

    // next_state[0] for in=0: A=0,B=0,C=0,D=1 => next_state[0]_0 = s1 & s0
    // next_state[0] for in=1: A=1,B=1,C=1,D=1 => next_state[0]_1 = 1'b1
    wire next_state_0_0 = s1 & s0;
    wire next_state_0_1 = 1'b1;
    assign next_state[0] = in ? next_state_0_1 : next_state_0_0;

endmodule