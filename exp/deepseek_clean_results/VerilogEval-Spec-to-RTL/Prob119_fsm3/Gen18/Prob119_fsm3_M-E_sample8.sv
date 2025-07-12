module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    reg [3:0] state;  // bits represent states [D C B A]

    // Next state logic (parallel computation)
    wire [3:0] next_state;
    assign next_state[0] = (~state[3] & ~state[2] & ~state[1] & ~in) |  // A stays A when in=0
                          (~state[3] & state[2] & ~state[1] & ~in);     // C goes A when in=0

    assign next_state[1] = (~state[3] & ~state[2] & ~state[1] & in) |   // A goes B when in=1
                          (~state[3] & ~state[2] & state[1] & in) |     // B stays B when in=1
                          (state[3] & ~state[2] & ~state[1] & in);      // D goes B when in=1

    assign next_state[2] = (~state[3] & ~state[2] & state[1] & ~in) |   // B goes C when in=0
                          (~state[3] & state[2] & ~state[1] & in) |     // C goes D when in=1
                          (state[3] & ~state[2] & ~state[1] & ~in);     // D goes C when in=0

    assign next_state[3] = (~state[3] & state[2] & ~state[1] & in);     // C goes D when in=1

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) state <= 4'b0001;  // Reset to state A
        else state <= next_state;
    end

    // Output logic (Moore) - simply output the D state bit
    assign out = state[3];

endmodule