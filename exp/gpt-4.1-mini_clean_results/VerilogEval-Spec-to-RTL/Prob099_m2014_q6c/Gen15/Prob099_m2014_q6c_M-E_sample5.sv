module TopModule(
    input  [5:0] y,  // current one-hot state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next state bit corresponding to y[0] (A)
    output       Y3  // next state bit corresponding to y[2] (C)
);

    // Local parameters for readability
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    // Current state signals
    wire A_cur = y[0];
    wire B_cur = y[1];
    wire C_cur = y[2];
    wire D_cur = y[3];
    wire E_cur = y[4];
    wire F_cur = y[5];

    // Next state bits as wires
    wire next_A, next_B, next_C, next_D, next_E, next_F;

    // State transitions from problem statement:
    // A (0) -> B ; (1) -> A
    assign next_A = (A_cur & w) | (D_cur & w);  
    // D_cur & w =1 -> A next as per transition D(0)->F(0), D(1)->A(1) (actually from original FSM D with w=1 -> A)
    // This matches that D_cur=1 & w=1 leads to A next state

    // B (0) -> C ; (1) -> D
    assign next_B = (A_cur & ~w);

    // C (0) -> E ; (1) -> D
    assign next_C = (B_cur & ~w) | (F_cur & ~w);

    // D (0) -> F ; (1) -> A
    assign next_D = (B_cur & w) | (C_cur & w) | (D_cur & w) | (E_cur & w) | (F_cur & w);

    // E (1) -> E ; (1) -> D
    // From E (w=1) -> E and D, from problem statement it's "E (1) -- 0 --> E" and "E (1) -- 1 --> D"
    // So E w=1-> D; w=0->E
    assign next_E = (C_cur & ~w) | (E_cur & ~w);

    // F (1) -> C ; (1) -> D
    // F (1) -- 0 --> C; F (1) -- 1 --> D
    assign next_F = (D_cur & ~w);

    // Correction after carefully checking transitions from problem:
    // Let's rewrite all next states carefully to match original FSM:

    // State A:
    // A (0) --0--> B (y[1])
    // A (0) --1--> A (y[0])
    // So next_B = A_cur & ~w
    // next_A = A_cur & w

    // State B:
    // B (0) --0--> C (y[2])
    // B (0) --1--> D (y[3])
    // next_C = B_cur & ~w
    // next_D = B_cur & w

    // State C:
    // C (0) --0--> E (y[4])
    // C (0) --1--> D (y[3])
    // next_E = C_cur & ~w
    // next_D = next_D | (C_cur & w) (include this additional)

    // State D:
    // D (0) --0--> F (y[5])
    // D (0) --1--> A (y[0])
    // next_F = D_cur & ~w
    // next_A = next_A | (D_cur & w)

    // State E:
    // E (1) --0--> E (y[4])
    // E (1) --1--> D (y[3])
    // next_E = next_E | (E_cur & ~w)
    // next_D = next_D | (E_cur & w)

    // State F:
    // F (1) --0--> C (y[2])
    // F (1) --1--> D (y[3])
    // next_C = next_C | (F_cur & ~w)
    // next_D = next_D | (F_cur & w)

    // Now combine all these:
    assign next_A = (A_cur & w) | (D_cur & w);
    assign next_B = (A_cur & ~w);
    assign next_C = (B_cur & ~w) | (F_cur & ~w);
    assign next_D = (B_cur & w) | (C_cur & w) | (D_cur & 0) /* no D->D w transitions */ | (E_cur & w) | (F_cur & w) | (C_cur & w);
    assign next_E = (C_cur & ~w) | (E_cur & ~w);
    assign next_F = (D_cur & ~w);

    // Note: D->D is not in FSM transitions, so remove (D_cur & 0)
    // Also (C_cur & w) appears twice, keep only once

    assign next_D = (B_cur & w) | (C_cur & w) | (E_cur & w) | (F_cur & w);

    // Outputs correspond to next state's bits of y[0] and y[2], i.e., states A and C next bits
    assign Y1 = next_A;
    assign Y3 = next_C;

endmodule