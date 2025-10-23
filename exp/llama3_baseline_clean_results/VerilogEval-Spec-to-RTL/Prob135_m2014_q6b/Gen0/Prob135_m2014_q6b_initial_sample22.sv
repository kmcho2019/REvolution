module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// Next state logic for y[1]
assign Y1 = (y == 3'b000 && w == 1'b0) ||  // A to B
             (y == 3'b001 && w == 1'b1) ||  // B to D
             (y == 3'b010 && w == 1'b1) ||  // C to D
             (y == 3'b011 && w == 1'b1) ||  // D to A (but y[1] is 0 in A, so not included)
             (y == 3'b100 && w == 1'b0) ||  // E stays in E with w=0 or goes to D with w=1
             (y == 3'b100 && w == 1'b1) ||  // E to D
             (y == 3'b101 && w == 1'b0);   // F to C

endmodule