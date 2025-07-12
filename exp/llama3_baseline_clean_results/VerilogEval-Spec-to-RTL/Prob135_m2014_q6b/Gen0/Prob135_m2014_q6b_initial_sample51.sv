module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // next state logic for y[1]
    wire next_y1;
    assign next_y1 = (~y[2] & ~y[1] & ~y[0] & w) |  // A(0) --> A(1)
                     (~y[2] & y[1] & ~y[0] & w) |  // B(0) --> D(1)
                     (~y[2] & ~y[1] & y[0] & w) |  // C(0) --> D(1)
                     (~y[2] & y[1] & y[0] & ~w) |  // D(0) --> A(1)
                     (~y[2] & y[1] & y[0] & w) |  // D(0) --> D(1)
                     (y[2] & ~y[1] & ~y[0] & w) |  // E(1) --> D(1)
                     (y[2] & y[1] & ~y[0] & w);  // F(1) --> D(1)

endmodule