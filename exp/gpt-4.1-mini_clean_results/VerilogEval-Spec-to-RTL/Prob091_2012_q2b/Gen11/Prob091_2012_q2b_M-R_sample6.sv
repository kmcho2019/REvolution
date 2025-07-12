module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;
    wire states_for_D = y[1] | y[2] | y[4] | y[5];

    assign Y1 = y[0] & w;
    assign Y3 = states_for_D & w_n;
endmodule