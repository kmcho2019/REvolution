module TopModule (
    input  wire [5:0] y,  // current state one-hot encoded
    input  wire w,        // FSM input
    output wire Y1,       // next input to flip-flop y[1]
    output wire Y3        // next input to flip-flop y[3]
);

// State bits:
// y[0] = A
// y[1] = B
// y[2] = C
// y[3] = D
// y[4] = E
// y[5] = F

// Y1 = next input for flip-flop y[1] (state B)
// From transitions, B is reached only from A with w=1
assign Y1 = y[0] & w;

// Y3 = next input for flip-flop y[3] (state D)
// D is reached from B,C,E,F with input=0
assign Y3 = ( (y[1] | y[2] | y[4] | y[5]) & (~w) );

endmodule