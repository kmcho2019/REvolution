module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output out
);

// Output is 1 only when in state D (11)
assign out = &state;  // Bitwise AND of both state bits (only true for 11)

// State transition logic using bitwise operations
always @(*) begin
    next_state[1] = (~state[1] & state[0] & ~in) |  // B->C when in=0
                    (state[1] & ~state[0]) |        // C->D when in=1 or D->C when in=0
                    (state[1] & state[0] & ~in);    // D->C when in=0

    next_state[0] = (~state[1] & ~state[0] & in) |  // A->B when in=1
                    (~state[1] & state[0] & in) |   // B->B when in=1
                    (state[1] & ~state[0] & in) |  // C->D when in=1
                    (state[1] & state[0] & in);    // D->B when in=1
end

endmodule