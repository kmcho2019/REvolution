module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding: A=000001, B=000010, C=000100, D=001000, E=010000, F=100000
    reg [5:0] state, next_state;

    wire A, B, C, D, E, F;
    assign {F, E, D, C, B, A} = state;

    // Next state logic implemented as combinational logic using assign
    // From FSM transitions:
    // A: w=0 -> B, w=1 -> A
    // B: w=0 -> C, w=1 -> D
    // C: w=0 -> E, w=1 -> D
    // D: w=0 -> F, w=1 -> A
    // E: w=0 -> E, w=1 -> D
    // F: w=0 -> C, w=1 -> D

    assign next_state[A] = (D & w) | (A & w);                  // next A from D(1) and A(1)
    assign next_state[B] = (A & ~w);                          // next B from A(0)
    assign next_state[C] = (B & ~w) | (F & ~w);               // next C from B(0) and F(0)
    assign next_state[D] = (B & w) | (C & w) | (E & w) | (F & w); // next D from B(1),C(1),E(1),F(1)
    assign next_state[E] = (C & ~w) | (E & ~w);               // next E from C(0),E(0)
    assign next_state[F] = (D & ~w);                          // next F from D(0)

    // Register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= 6'b000001; // state A initial
        else
            state <= next_state;
    end

    // Output logic: z=1 when in E or F
    assign z = E | F;

endmodule