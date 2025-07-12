module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Transition masks for in=0 case
    wire [3:0] trans_0 = {state[1] | state[3],  // Next state[0] = from B or D
                          1'b0,                // Next state[1] = never set
                          state[1] | state[3],  // Next state[2] = from B or D
                          1'b0};               // Next state[3] = never set

    // Transition masks for in=1 case
    wire [3:0] trans_1 = {1'b0,                // Next state[0] = never set
                          state[0] | state[2] | state[3],  // Next state[1] = from A, C or D
                          1'b0,                // Next state[2] = never set
                          state[2]};          // Next state[3] = from C

    // Combine transitions based on input
    assign next_state = (in ? trans_1 : trans_0) | 
                       (state & {4{~in}} & {state[0], 1'b0, 1'b0, 1'b0});  // Handle A staying in A when in=0

    // Output is high only in state D (one-hot MSB)
    assign out = state[3];

endmodule