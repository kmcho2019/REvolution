module TopModule (
    input  [5:0] y, // state variable
    input        w, // input to the state machine
    output       Y2, // next-state signal for y[1]
    output       Y4  // next-state signal for y[3]
);

// Next-state logic for Y2 (y[1])
assign Y2 = (y[5:0] == 6'b000010 && !w) || // B to C
           (y[5:0] == 6'b000100 && !w) || // C to E
           (y[5:0] == 6'b001000 && !w) || // D to F
           (y[5:0] == 6'b000001 && w) || // A to B
           (y[5:0] == 6'b001000 && w) || // D to A
           (y[5:0] == 6'b100000 && w); // F to D

// Next-state logic for Y4 (y[3])
assign Y4 = (y[5:0] == 6'b000001 && !w) || // A to B
           (y[5:0] == 6'b000010 && !w) || // B to C
           (y[5:0] == 6'b000100 && !w) || // C to E
           (y[5:0] == 6'b010000 && !w) || // E to E
           (y[5:0] == 6'b000100 && w) || // C to D
           (y[5:0] == 6'b100000 && !w) || // F to C
           (y[5:0] == 6'b001000 && !w); // D to F

endmodule