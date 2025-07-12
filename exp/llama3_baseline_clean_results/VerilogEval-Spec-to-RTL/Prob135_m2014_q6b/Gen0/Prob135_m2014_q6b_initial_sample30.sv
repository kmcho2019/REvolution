module TopModule(
    input  [2:0] y,  // current state
    input  w,       // input
    output Y1       // output
);

// next-state logic for y[1]
assign Y1 = (y == 3'b000 && w) || (y == 3'b001 && w) || (y == 3'b100) || (y == 3'b101);

endmodule