module TopModule (
    input  wire [5:0] y,
    input  wire       w,
    output wire       Y1,
    output wire       Y3
);

    // Y1 is input to state flip-flop y[1] (state B)
    // Y1 = from A (y[0]) with w=1
    assign Y1 = y[0] & w;

    // Y3 is input to state flip-flop y[3] (state D)
    // D transitions from B(1), C(2), E(4), F(5) when w=0
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule