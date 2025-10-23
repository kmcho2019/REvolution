module TopModule (
    input  [5:0] y,  // one-hot encoded current state: A..F = y[0]..y[5]
    input        w,  // input signal
    output       Y2, // next state signal for state B (y[1])
    output       Y4  // next state signal for state D (y[3])
);

assign Y2 = y[0] & ~w;                         // A --0--> B
assign Y4 = (y[1] | y[2] | y[4] | y[5]) & w;  // B,C,E,F --1--> D

endmodule