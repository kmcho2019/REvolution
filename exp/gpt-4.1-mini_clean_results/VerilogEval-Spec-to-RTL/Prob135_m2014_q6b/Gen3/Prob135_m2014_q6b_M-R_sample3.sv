module TopModule(
    input  [2:0] y,  // current state encoding
    input  w,
    output Y1
);

    // States encoding for clarity
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;

    // next_y1 combinational logic derived from transitions:
    // next_y1 = 1 if:
    //   - state B (001)
    //   - state C (010) and w=1
    //   - state E (100) and w=1
    //   - state F (101)
    // Otherwise 0.
    wire is_B = (y == B);
    wire is_C = (y == C);
    wire is_E = (y == E);
    wire is_F = (y == F);

    wire next_y1 = is_B
                   | (is_C & w)
                   | (is_E & w)
                   | is_F;

    assign Y1 = y[1]; // output current y[1]

endmodule