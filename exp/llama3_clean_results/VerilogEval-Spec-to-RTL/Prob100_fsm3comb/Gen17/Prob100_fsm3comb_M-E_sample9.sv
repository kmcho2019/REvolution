module TopModule(
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

always @(in, state) begin
    // Next state logic using Karnaugh map minimization
    next_state[0] = (~state[1] & ~state[0] & ~in) | (~state[1] & state[0] & ~in) | (state[1] & ~state[0] & in) | (state[1] & state[0] & ~in);
    next_state[1] = (~state[1] & ~state[0] & in) | (state[1] & ~state[0] & ~in) | (state[1] & state[0] & in);

    // Output logic
    out = state[1] & state[0];
end

endmodule