module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;
    wire any_y_1_2_4_5 = y[1] | y[2] | y[4] | y[5];

    // Direct combinational assignments for next state inputs
    assign Y1 = y[0] & w;
    assign Y3 = w_n & any_y_1_2_4_5;

endmodule