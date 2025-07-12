module TopModule(
    input  [5:0] y,  // 6-bit one-hot encoded state
    input  w,      // input to determine next state
    output Y1,     // input to state flip-flop y[1]
    output Y3      // input to state flip-flop y[3]
);

// A (000001), B (000010), C (000100), D (001000), E (010000), F (100000)

// Next state logic for Y1
assign Y1 = (y[0] && w) ||  // A to B
           (y[1] && ~w) ||  // B to D
           (y[3] && (w || ~w));  // D to D or other

// Next state logic for Y3
assign Y3 = (y[1] && w) ||  // B to C
           (y[2] && ~w) ||  // C to D
           (y[3] && (w || ~w)) ||  // D to D or other
           (y[4] && ~w);  // E to D

endmodule