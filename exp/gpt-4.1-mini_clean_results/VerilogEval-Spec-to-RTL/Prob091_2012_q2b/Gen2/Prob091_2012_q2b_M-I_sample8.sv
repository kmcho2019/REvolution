module TopModule(
    input  wire [5:0] y,
    input  wire w,
    output wire Y1,
    output wire Y3
);

    // Y1 is input for flip-flop y[1], triggered by state A with w=1
    assign Y1 = y[0] & w;

    // Internal wire to reduce fanout and gate count for Y3 computation
    wire y_1_2_4_5 = y[1] | y[2] | y[4] | y[5];

    // Y3 is input for flip-flop y[3], triggered by states B,C,E,F with w=0
    assign Y3 = y_1_2_4_5 & ~w;

endmodule