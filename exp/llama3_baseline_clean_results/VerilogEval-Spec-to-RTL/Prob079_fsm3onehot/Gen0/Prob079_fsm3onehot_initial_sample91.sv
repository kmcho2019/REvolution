module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    // One-hot state encoding
    wire state_A = state[0]; // 4'b0001
    wire state_B = state[1]; // 4'b0010
    wire state_C = state[2]; // 4'b0100
    wire state_D = state[3]; // 4'b1000

    // Next state logic
    assign next_state[0] = (~in & state_A) | (~in & state_C);
    assign next_state[1] = (in & state_A) | (~in & state_B) | (in & state_D);
    assign next_state[2] = (~in & state_B) | (in & state_C);
    assign next_state[3] = (in & state_C);

    // Output logic
    assign out = state_D;

endmodule