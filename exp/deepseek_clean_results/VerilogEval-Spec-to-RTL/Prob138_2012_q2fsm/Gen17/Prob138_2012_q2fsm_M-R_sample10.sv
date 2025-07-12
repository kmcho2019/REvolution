module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding (modified Gray code with z=state[2])
    // A=000, B=001, C=011, D=010, E=110, F=100
    // Benefits: Only 1-bit changes between most transitions
    //           Output z is directly available as state[2]
    reg [2:0] state;

    // Next state logic - implemented with continuous assignments
    wire [2:0] next_state;
    assign next_state[0] = (~state[2] & ~state[1] & ~state[0] & w) |  // A->B
                          (~state[2] & ~state[1] & state[0] & ~w) |  // B->D
                          (~state[2] & state[1] & state[0] & ~w) |    // C->D
                          (~state[2] & state[1] & ~state[0] & ~w) |   // D->A
                          (state[2] & state[1] & ~state[0] & ~w) |    // E->D
                          (state[2] & ~state[1] & ~state[0] & ~w);    // F->D

    assign next_state[1] = (~state[2] & ~state[1] & state[0] & w) |   // B->C
                          (~state[2] & state[1] & state[0] & w) |     // C->E
                          (~state[2] & state[1] & ~state[0] & w) |    // D->F
                          (state[2] & state[1] & ~state[0] & w) |     // E->E
                          (state[2] & ~state[1] & ~state[0] & w);      // F->C

    assign next_state[2] = (~state[2] & state[1] & state[0] & w) |    // C->E
                          (~state[2] & state[1] & ~state[0] & w) |    // D->F
                          (state[2] & state[1] & ~state[0]) |         // E stays
                          (state[2] & ~state[1] & ~state[0]);         // F stays

    // State register with synchronous reset
    always @(posedge clk)
        state <= reset ? 3'b000 : next_state;

    // Output is directly state[2] (E=110 and F=100)
    assign z = state[2];

endmodule