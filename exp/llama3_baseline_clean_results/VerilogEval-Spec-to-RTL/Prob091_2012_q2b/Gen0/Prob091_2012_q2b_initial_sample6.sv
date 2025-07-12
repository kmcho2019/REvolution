module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// One-hot encoding for states: A (000001), B (000010), C (000100), D (001000), E (010000), F (100000)

// Output logic for Y1
assign Y1 = (y[1] && w) || (y[4] && w) || (y[5] && w);

// Output logic for Y3
assign Y3 = (y[3] && w) || (y[4] && w) || (y[5] && w) || (y[1] && ~w) || (y[2] && ~w) || (y[5] && ~w);

endmodule