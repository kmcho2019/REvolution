module TopModule (
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

    // next_state is zeroed then only one bit is set depending on current state and input
    assign next_state = (state[0] ? (in ? 4'b0010 : 4'b0001) :  // A -> B or A
                         state[1] ? (in ? 4'b0010 : 4'b0100) :  // B -> B or C
                         state[2] ? (in ? 4'b1000 : 4'b0001) :  // C -> D or A
                         state[3] ? (in ? 4'b0010 : 4'b0100) :  // D -> B or C
                         4'b0000);

    assign out = state[3];

endmodule