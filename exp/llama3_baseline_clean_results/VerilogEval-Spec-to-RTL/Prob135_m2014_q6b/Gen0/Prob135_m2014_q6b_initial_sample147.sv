module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1]
assign Y1 = (y == 3'b001 && w) ||  // B to D
             (y == 3'b100 && w) ||  // C to D
             (y == 3'b101) ||       // E remains E or goes to D
             (y == 3'b110 && w) ||  // F to D
             (y == 3'b011 && ~w);   // D to F

endmodule