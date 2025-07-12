module TopModule(
    input  wire [5:0] y,
    input  wire w,
    output wire Y1,
    output wire Y3
);

    // Y1 is input for flip-flop y[1], triggered by state A with w=1
    assign Y1 = y[0] & w;

    // Y3 is input for flip-flop y[3], triggered by states B,C,E,F with w=0
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;

endmodule