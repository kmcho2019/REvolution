module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // next-state logic for y[1]
    wire next_y1;
    assign next_y1 = (y == 3'b001 && w) || // current state B, w = 1, next state D
                     (y == 3'b011 && w == 0) || // current state D, w = 0, next state F
                     (y == 3'b101 && w) || // current state F, w = 1, next state D
                     (y == 3'b100 && w == 1); // current state E, w = 1, next state D

endmodule