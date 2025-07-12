module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Transition masks for each state (in=0, in=1)
    wire [3:0] trans_A = in ? 4'b0010 : 4'b0001;  // A -> B or A
    wire [3:0] trans_B = in ? 4'b0010 : 4'b0100;  // B -> B or C
    wire [3:0] trans_C = in ? 4'b1000 : 4'b0001;  // C -> D or A
    wire [3:0] trans_D = in ? 4'b0010 : 4'b0100;  // D -> B or C

    // Select appropriate transition based on current state
    assign next_state = (state[0] ? trans_A :
                        state[1] ? trans_B :
                        state[2] ? trans_C :
                        state[3] ? trans_D : 4'b0000);

    // Output is high only in state D
    assign out = state[3];

endmodule