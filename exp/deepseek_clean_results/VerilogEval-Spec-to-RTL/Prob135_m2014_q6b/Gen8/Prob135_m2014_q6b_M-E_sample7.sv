module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    // State definitions for clarity
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;

    // Intermediate transition signals
    wire from_A = (y == A);
    wire from_B = (y == B);
    wire from_C = (y == C);
    wire from_D = (y == D);
    wire from_E = (y == E);
    wire from_F = (y == F);

    // Transition conditions for y[1]
    wire A_trans = from_A & ~w;  // A->B when w=0 (y[1] stays 0)
    wire B_trans = from_B & w;    // B->D when w=1 (y[1] becomes 1)
    wire C_trans = from_C & w;    // C->D when w=1 (y[1] becomes 1)
    wire D_trans = from_D & w;    // D->A when w=1 (y[1] becomes 0)
    wire E_trans = from_E & w;    // E->D when w=1 (y[1] stays 1)
    wire F_trans = from_F & w;    // F->D when w=1 (y[1] stays 1)

    // Next state logic for y[1] using prioritized conditions
    assign Y1 = (B_trans | C_trans | E_trans | F_trans) ? 1'b1 :
                (D_trans) ? 1'b0 :
                // Default cases maintain current y[1]
                (from_A | from_B | from_C) ? 1'b0 :
                (from_D | from_E | from_F) ? 1'b1 :
                1'b0;  // catch-all (shouldn't occur with valid states)

endmodule