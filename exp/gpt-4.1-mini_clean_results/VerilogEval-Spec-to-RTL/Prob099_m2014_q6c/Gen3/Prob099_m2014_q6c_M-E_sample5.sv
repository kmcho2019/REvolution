module TopModule (
    input  [5:0] y,   // One-hot current state vector: y[0]=A, ..., y[5]=F
    input        w,
    output       Y2,  // Next state bit for B (y[1])
    output       Y4   // Next state bit for D (y[3])
);

// Define wires for next state bits for all states A-F
wire [5:0] next_y;

// State A (y[0]) transitions:
//   w=0 -> B(y[1])
//   w=1 -> A(y[0])
assign next_y[0] = y[0] & w;      // A on w=1 from A
assign next_y[1] = y[0] & ~w;     // B on w=0 from A

// State B (y[1]) transitions:
//   w=0 -> C(y[2])
//   w=1 -> D(y[3])
assign next_y[2] = y[1] & ~w;     // C on w=0 from B
assign next_y[3] = y[1] & w;      // D on w=1 from B

// State C (y[2]) transitions:
//   w=0 -> E(y[4])
//   w=1 -> D(y[3])
assign next_y[4] = y[2] & ~w;     // E on w=0 from C
assign next_y[3] = next_y[3] | (y[2] & w);  // D on w=1 from C

// State D (y[3]) transitions:
//   w=0 -> F(y[5])
//   w=1 -> A(y[0])
assign next_y[5] = y[3] & ~w;     // F on w=0 from D
assign next_y[0] = next_y[0] | (y[3] & w);  // A on w=1 from D

// State E (y[4]) transitions (w=1 input is specified, assume w=1 only):
//   w=0 -> E(y[4])
//   w=1 -> D(y[3])
assign next_y[4] = next_y[4] | (y[4] & ~w); // E on w=0 from E
assign next_y[3] = next_y[3] | (y[4] & w);  // D on w=1 from E

// State F (y[5]) transitions:
//   w=0 -> C(y[2])
//   w=1 -> D(y[3])
assign next_y[2] = next_y[2] | (y[5] & ~w); // C on w=0 from F
assign next_y[3] = next_y[3] | (y[5] & w);  // D on w=1 from F

// Outputs correspond to next state bits for B and D
assign Y2 = next_y[1];
assign Y4 = next_y[3];

endmodule