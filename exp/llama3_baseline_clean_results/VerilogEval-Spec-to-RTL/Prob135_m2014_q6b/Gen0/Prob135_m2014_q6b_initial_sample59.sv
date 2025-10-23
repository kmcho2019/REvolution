module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    // Next state logic for y[1]
    assign Y1 = (y == 3'b001 && w) || (y == 3'b100 && w) || (y == 3'b101 && w) || (y == 3'b110 && w) || (y == 3'b111 && ~w) || (y == 3'b101);

    // However, as per the problem, Y1 is just the current state of y[1], so the correct implementation should be:
    assign Y1 = y[1];

endmodule