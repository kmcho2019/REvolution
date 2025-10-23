module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    parameter [5:0] A = 6'b000001,
                    B = 6'b000010,
                    C = 6'b000100,
                    D = 6'b001000,
                    E = 6'b010000,
                    F = 6'b100000;

    reg [5:0] state;

    // Next state logic (combinational)
    wire [5:0] next_state;
    assign next_state[A] = (state[A] & w) | (state[D] & w) | reset;
    assign next_state[B] = (state[A] & ~w) | reset;
    assign next_state[C] = (state[B] & ~w) | (state[F] & ~w) | reset;
    assign next_state[D] = (state[B] & w) | (state[C] & w) | (state[E] & w) | (state[F] & w) | (state[D] & ~w) | reset;
    assign next_state[E] = (state[C] & ~w) | (state[E] & ~w) | reset;
    assign next_state[F] = (state[D] & ~w) | reset;

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic - E and F states produce z=1
    assign z = state[E] | state[F];

endmodule