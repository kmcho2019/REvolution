module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Y1 is high when the next state is B or D
assign Y1 = (y[5:0] == 6'b000001 && w == 0) || // A (0) -> A, no change
           (y[5:0] == 6'b000010 && w == 0) || // B (0) -> D, y[1] is set
           (y[5:0] == 6'b000100 && w == 0) || // C (0) -> D, y[1] is set
           (y[5:0] == 6'b001000 && w == 0) || // D (0) -> A, y[1] is set
           (y[5:0] == 6'b001000 && w == 1) || // D (1) -> F, y[1] is set
           (y[5:0] == 6'b010000 && w == 0) || // E (0) -> D, y[1] is set
           (y[5:0] == 6'b100000 && w == 0);   // F (0) -> D, y[1] is set

// Y3 is high when the next state is D
assign Y3 = (y[5:0] == 6'b000001 && w == 1) || // A (0) -> B, no change
           (y[5:0] == 6'b000010 && w == 0) || // B (0) -> D, y[3] is set
           (y[5:0] == 6'b000100 && w == 0) || // C (0) -> D, y[3] is set
           (y[5:0] == 6'b001000 && w == 0) || // D (0) -> A, y[3] is set
           (y[5:0] == 6'b001000 && w == 1) || // D (1) -> F, y[3] is set
           (y[5:0] == 6'b010000 && w == 0) || // E (0) -> D, y[3] is set
           (y[5:0] == 6'b100000 && w == 0);   // F (0) -> D, y[3] is set

endmodule