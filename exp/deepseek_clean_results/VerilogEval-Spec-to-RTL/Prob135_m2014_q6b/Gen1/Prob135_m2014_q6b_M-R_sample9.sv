module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

// State definitions
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Next-state logic for y[1]
wire y1_next = 
    ((y == B) & ~w) |         // B->C (y[1] becomes 1)
    ((y == B) & w) |          // B->D (y[1] becomes 1)
    ((y == C) & w) |          // C->D (y[1] stays 1)
    ((y == D) & ~w) |         // D->F (y[1] stays 1)
    ((y == E) & w) |          // E->D (y[1] becomes 1)
    ((y == F) & w);           // F->D (y[1] becomes 1)

assign Y1 = y[1];

endmodule