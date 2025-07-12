module TopModule (
    input  wire [5:0] y,  // One-hot current state vector
    input  wire       w,  // Input signal
    output wire       Y1, // Next state input for flip-flop y[1] (state B)
    output wire       Y3  // Next state input for flip-flop y[3] (state D)
);

// Define state bit positions for clarity
localparam A = 0;
localparam B = 1;
localparam C = 2;
localparam D = 3;
localparam E = 4;
localparam F = 5;

// Y1 input corresponds to next state B
// Transition: A --1--> B
assign Y1 = y[A] & w;

// Y3 input corresponds to next state D
// Transitions:
// B --0--> D
// C --0--> D
// E --0--> D
// F --0--> D
// So Y3 = (~w) & (y[B] | y[C] | y[E] | y[F])
assign Y3 = (~w) & (y[B] | y[C] | y[E] | y[F]);

endmodule