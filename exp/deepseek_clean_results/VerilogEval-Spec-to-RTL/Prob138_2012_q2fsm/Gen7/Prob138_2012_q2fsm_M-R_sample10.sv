module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam A = 6'b000001,
               B = 6'b000010,
               C = 6'b000100,
               D = 6'b001000,
               E = 6'b010000,
               F = 6'b100000;

    reg [5:0] state, next_state;

    // Continuous assignments for state transitions
    assign next_state[A] = (state[A] & ~w) | (state[D] & ~w);
    assign next_state[B] = (state[A] & w);
    assign next_state[C] = (state[B] & w) | (state[F] & w);
    assign next_state[D] = (state[B] & ~w) | (state[C] & ~w) | 
                          (state[E] & ~w) | (state[F] & ~w);
    assign next_state[E] = (state[C] & w) | (state[E] & w);
    assign next_state[F] = (state[D] & w);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output z is high when in states E or F
    assign z = state[E] | state[F];

endmodule