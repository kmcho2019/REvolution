module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

    // Y2 is set to 1 when the current state is B and w is 1, or when the current state is E and w is 1, or when the current state is C and w is 0
    assign Y2 = (y[1] && w) || (y[4] && w) || (y[2] && ~w);
    // Y4 is set to 1 when the current state is D and w is 0, or when the current state is F and w is 1, or when the current state is E and w is 0
    assign Y4 = (y[3] && ~w) || (y[5] && w) || (y[4] && ~w);

    // The problem description does not specify the logic for Y1 and Y3, so I assume they are not used
    assign Y1 = 0;
    assign Y3 = 0;

endmodule