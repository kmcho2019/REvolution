module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    localparam STATE_A = 3'b000;
    localparam STATE_B = 3'b001;
    localparam STATE_C = 3'b010;
    localparam STATE_D = 3'b011;
    localparam STATE_E = 3'b100;
    localparam STATE_F = 3'b101;

    assign Y1 = (
        // A (0) --0--> B, A (0) --1--> A
        (y == STATE_A && !w && !y[1]) ||
        // B (0) --0--> C, B (0) --1--> D
        (y == STATE_B && !w && !y[1]) ||
        // C (0) --0--> E, C (0) --1--> D
        (y == STATE_C && !w && y[1]) ||
        // D (0) --0--> F, D (0) --1--> A
        (y == STATE_D && !y[1]) ||
        // E (1) --0--> E, E (1) --1--> D
        (y == STATE_E && y[1]) ||
        // F (1) --0--> C, F (1) --1--> D
        (y == STATE_F && y[1] && !w) ||
        // Transition to D from various states
        (y == STATE_B && w && y[1]) ||
        (y == STATE_C && w && y[1]) ||
        (y == STATE_E && w && y[1]) ||
        (y == STATE_F && w && y[1])
    );

endmodule