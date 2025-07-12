module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // State bits for readability
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic as sum of products explicitly from table
    assign next_state[0] = (~in & A) | (~in & C);                    // Next state A
    assign next_state[1] = (in & A) | (in & B) | (in & D);           // Next state B
    assign next_state[2] = (~in & B) | (~in & D);                    // Next state C
    assign next_state[3] = (in & C);                                 // Next state D

    // Output high only in state D (one-hot)
    assign out = D;

endmodule