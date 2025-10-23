module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding: [F, E, D, C, B, A]
    reg [5:0] state;

    // Next state logic
    wire [5:0] next_state;
    assign next_state[5] = (~w & state[3]) | (~w & state[1]); // F = (~w & D) | (~w & F)
    assign next_state[4] = (~w & state[2]) | (state[4] & ~w); // E = (~w & C) | (E & ~w)
    assign next_state[3] = (w & state[5]) | (w & state[4]) | (w & state[2]) | (w & state[1]) | (w & state[0]); // D = w & (F|E|C|B|A)
    assign next_state[2] = (~w & state[1]); // C = ~w & B
    assign next_state[1] = (~w & state[0]); // B = ~w & A
    assign next_state[0] = (w & state[0]) | (w & state[3]); // A = (w & A) | (w & D)

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001; // Reset to state A
        else
            state <= next_state;
    end

    // Output logic - z is high when in state E or F
    assign z = state[5] | state[4];

endmodule