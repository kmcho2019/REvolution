module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);
    // One-hot state signals
    wire A = state[0];
    wire B = state[1];
    wire C = state[2];
    wire D = state[3];

    // Next state logic (explicit boolean expressions)
    assign next_state[0] = (~in & A) | (~in & C);             // A next
    assign next_state[1] = ( in & A) | (in & B) | (in & D);   // B next
    assign next_state[2] = (~in & B) | (~in & D);             // C next
    assign next_state[3] =  in & C;                            // D next

    // Output high only in state D
    assign out = D;

endmodule