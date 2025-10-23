module TopModule(
    input  [5:0] y,  // current one-hot state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2, // next state bit for B (y[1])
    output       Y4  // next state bit for D (y[3])
);

    // Define state encoding indices for readability
    localparam A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;

    reg [5:0] next_state;

    always @(*) begin
        // Default next state is zero vector (no state)
        next_state = 6'b000000;

        // Identify current state by checking which bit in y is set
        if (y[A]) begin
            // State A transitions
            if (w == 1'b0) next_state[B] = 1'b1; else next_state[A] = 1'b1;
        end else if (y[B]) begin
            // State B transitions
            if (w == 1'b0) next_state[C] = 1'b1; else next_state[D] = 1'b1;
        end else if (y[C]) begin
            // State C transitions
            if (w == 1'b0) next_state[E] = 1'b1; else next_state[D] = 1'b1;
        end else if (y[D]) begin
            // State D transitions
            if (w == 1'b0) next_state[F] = 1'b1; else next_state[A] = 1'b1;
        end else if (y[E]) begin
            // State E transitions
            if (w == 1'b0) next_state[E] = 1'b1; else next_state[D] = 1'b1;
        end else if (y[F]) begin
            // State F transitions
            if (w == 1'b0) next_state[C] = 1'b1; else next_state[D] = 1'b1;
        end else begin
            // If no valid state, reset to A
            next_state[A] = 1'b1;
        end
    end

    // Outputs correspond to next state bits B and D
    assign Y2 = next_state[B];
    assign Y4 = next_state[D];

endmodule