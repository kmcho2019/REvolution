module TopModule (
    input  wire [5:0] y,  // current state one-hot encoded: A= y[0], B= y[1], C= y[2], D= y[3], E= y[4], F= y[5]
    input  wire       w,  // FSM input
    output wire       Y1, // input for flip-flop y[1] (state B)
    output wire       Y3  // input for flip-flop y[3] (state D)
);

// Next state logic for B (Y1):
// B is entered only from A when w=1
assign Y1 = y[0] & w;

// Next state logic for D (Y3):
// D is entered from B, C, E, or F when w=0
assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule