module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    reg [5:0] state;

    // State transition logic
    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001;  // State A
        else begin
            // Parallel state transitions
            state[0] <= (state[0] & w) | (state[3] & w);  // A stays or D->A
            state[1] <= (state[0] & ~w);                  // A->B
            state[2] <= (state[1] & ~w) | (state[5] & ~w); // B->C or F->C
            state[3] <= (state[1] & w) | (state[2] & w) | (state[4] & w) | (state[5] & w); // B/D/E/F->D
            state[4] <= (state[2] & ~w) | (state[4] & ~w); // C->E or E stays
            state[5] <= (state[3] & ~w);                  // D->F
        end
    end

    // Output is OR of E and F states
    assign z = state[4] | state[5];

endmodule