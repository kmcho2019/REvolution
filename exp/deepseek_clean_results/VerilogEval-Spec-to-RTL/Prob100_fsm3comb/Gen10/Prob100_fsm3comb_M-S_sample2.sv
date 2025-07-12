module TopModule (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

always @(*) begin
    out = (state == 2'b11);  // Output is 1 only in state D
    
    // State transitions using ternary operators
    next_state[1] = (state[1] & ~state[0] & ~in) |  // C->A (10->00)
                    (state[1] & state[0] & ~in) |    // D->C (11->10)
                    (~state[1] & state[0] & ~in);    // B->C (01->10)
                    
    next_state[0] = (~state[1] & ~state[0] & in) |  // A->B (00->01)
                    (~state[1] & state[0]) |        // B stays on in=1 (01->01)
                    (state[1] & ~state[0] & in) |   // C->D (10->11)
                    (state[1] & state[0] & in);     // D->B (11->01)
end

endmodule