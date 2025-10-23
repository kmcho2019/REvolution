module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // One-hot encoding for states
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // Next state logic using continuous assignments
    wire next_A = (state[D] & ~w) | (state[A] & ~w);
    wire next_B = (state[A] & w);
    wire next_C = (state[B] & w) | (state[F] & w);
    wire next_D = (state[B] & ~w) | (state[C] & ~w) | (state[E] & ~w) | (state[F] & ~w) | (state[D] & 1'b0);
    wire next_E = (state[C] & w) | (state[E] & w);
    wire next_F = (state[D] & w);

    // Combine to next_state vector
    assign next_state = {next_F, next_E, next_D, next_C, next_B, next_A};

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: z=1 only in E or F states
    assign z = state[E] | state[F];

endmodule