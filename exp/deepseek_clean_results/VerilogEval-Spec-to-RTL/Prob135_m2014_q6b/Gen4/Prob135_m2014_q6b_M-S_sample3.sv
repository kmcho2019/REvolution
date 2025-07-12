module TopModule (
    input [2:0] y,    // Current state (3-bit input)
    input w,          // Input signal
    output Y1         // Output y[1]
);

// Next-state logic for y[1] only
wire next_y1;
assign next_y1 = (y == 3'b000 && w) ? 1'b0 :  // A->A (y[1] stays 0)
                 (y == 3'b000 && ~w) ? 1'b0 : // A->B (y[1] stays 0)
                 (y == 3'b001 && w) ? 1'b1 :  // B->D (y[1] becomes 1)
                 (y == 3'b001 && ~w) ? 1'b0 : // B->C (y[1] stays 0)
                 (y == 3'b010 && w) ? 1'b1 :  // C->D (y[1] becomes 1)
                 (y == 3'b010 && ~w) ? 1'b0 : // C->E (y[1] stays 0)
                 (y == 3'b011 && w) ? 1'b0 :  // D->A (y[1] becomes 0)
                 (y == 3'b011 && ~w) ? 1'b1 : // D->F (y[1] stays 1)
                 (y == 3'b100 && w) ? 1'b1 :  // E->D (y[1] stays 1)
                 (y == 3'b100 && ~w) ? 1'b0 : // E->E (y[1] stays 0)
                 (y == 3'b101 && w) ? 1'b1 :  // F->D (y[1] stays 1)
                 (y == 3'b101 && ~w) ? 1'b0 : // F->C (y[1] becomes 0)
                 1'b0;                         // Default case

// Output assignment (current y[1], not next state)
assign Y1 = y[1];

endmodule