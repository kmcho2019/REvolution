module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 remains the same - optimal implementation
    assign Y1 = y[0] & w;

    // Improved Y3 logic using positive detection of states B,C,E,F
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule