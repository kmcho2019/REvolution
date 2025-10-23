module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output wire z
);

    // One-hot state encoding
    // 6 states: A, B, C, D, E, F
    reg A, B, C, D, E, F;
    reg A_next, B_next, C_next, D_next, E_next, F_next;

    // Next state logic using Boolean equations derived from the FSM transitions:
    // A' = (A & w) | (D & w)                 -- A -> A on w=1, D -> A on w=1
    // B' = (A & ~w)                         -- A -> B on w=0
    // C' = (B & ~w) | (F & ~w)             -- B->C w=0, F->C w=0
    // D' = (B & w) | (C & w) | (E & w) | (F & w)  -- multiple transitions on w=1 to D
    // E' = (C & ~w) | (E & ~w)             -- C->E w=0, E->E w=0
    // F' = (D & ~w)                        -- D->F w=0

    always @(*) begin
        A_next = (A & w) | (D & w);
        B_next = A & ~w;
        C_next = (B & ~w) | (F & ~w);
        D_next = (B & w) | (C & w) | (E & w) | (F & w);
        E_next = (C & ~w) | (E & ~w);
        F_next = D & ~w;
    end

    // Sequential state updates
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 1'b1; // start state is A
            B <= 1'b0;
            C <= 1'b0;
            D <= 1'b0;
            E <= 1'b0;
            F <= 1'b0;
        end else begin
            A <= A_next;
            B <= B_next;
            C <= C_next;
            D <= D_next;
            E <= E_next;
            F <= F_next;
        end
    end

    // Output z is high only when in states E or F
    assign z = E | F;

endmodule