module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Define the next-state logic using a lookup table approach
    assign Y1 = (y[0] && w) || (y[1] && ~w) || (y[2] && ~w) || (y[4] && w) || (y[5] && w);
    assign Y3 = (y[1] && w) || (y[2] && w) || (y[3] && ~w) || (y[4] && ~w) || (y[5] && ~w);

endmodule