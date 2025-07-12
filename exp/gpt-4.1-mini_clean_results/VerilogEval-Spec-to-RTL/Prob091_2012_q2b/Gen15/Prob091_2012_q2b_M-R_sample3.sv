module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // State encodings for clarity (one-hot)
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    // Next state input for y[1] (state B): from state A on w=1
    assign Y1 = y[0] & w;

    // Next state input for y[3] (state D): from states B,C,E,F on w=0
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & (~w);

endmodule