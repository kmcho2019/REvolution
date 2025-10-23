module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    reg [5:0] state;
    parameter A = 6'b000001;
    parameter B = 6'b000010;
    parameter C = 6'b000100;
    parameter D = 6'b001000;
    parameter E = 6'b010000;
    parameter F = 6'b100000;

    // Next state logic
    wire [5:0] next_state;
    assign next_state[0] = (~state[0] | ~w) &  // A->A (w=0) or not in A
                         (state[3] & ~w) |    // D->A (w=0)
                         (~|state);           // Default to A when no state set

    assign next_state[1] = (state[0] & w) |   // A->B (w=1)
                          (state[5] & ~w);    // F->B (invalid, but included for completeness)

    assign next_state[2] = (state[1] & w) |   // B->C (w=1)
                          (state[5] & w);     // F->C (w=1)

    assign next_state[3] = (state[1] & ~w) |  // B->D (w=0)
                          (state[2] & ~w) |   // C->D (w=0)
                          (state[4] & ~w) |   // E->D (w=0)
                          (state[5] & ~w);   // F->D (w=0)

    assign next_state[4] = (state[2] & w) |   // C->E (w=1)
                          (state[4] & w);     // E->E (w=1)

    assign next_state[5] = (state[3] & w);    // D->F (w=1)

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Registered output (E or F states)
    always @(posedge clk) begin
        if (reset)
            z <= 1'b0;
        else
            z <= state[4] | state[5];  // E or F states
    end

endmodule