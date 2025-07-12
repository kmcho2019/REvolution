module TopModule(
    input [2:0] y,  // current state
    input w,      // input signal
    output Y1     // output signal
);

// next-state logic for y[1]
assign Y1 = (y == 3'b001 && w) || (y == 3'b010 && w) || (y == 3'b100 && w) || (y == 3'b101 && w) || (y == 3'b111 && ~w);

endmodule