module TopModule(
    input [2:0] y,  // current state
    input w,       // input
    output Y1      // output
);

// Next-state logic for y[1]
assign Y1 = (y == 3'b000 && w == 1) || // A(0) -> A
           (y == 3'b001 && w == 1) || // B(0) -> D
           (y == 3'b011 && w == 1) || // C(0) -> D
           (y == 3'b100 && w == 1) || // D(0) -> A
           (y == 3'b101 && w == 1) || // E(1) -> D
           (y == 3'b110 && w == 1);   // F(1) -> D

endmodule