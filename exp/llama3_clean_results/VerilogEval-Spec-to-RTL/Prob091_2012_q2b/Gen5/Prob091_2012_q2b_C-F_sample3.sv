module StateBNext(
    input  [5:0] y,
    input  w,
    output Y1
);

    // Direct and efficient assignment for Y1
    assign Y1 = y[0] && w;

endmodule

module StateDNext(
    input  [5:0] y,
    input  w,
    output Y3
);

    // Simplified conditional assignment for Y3
    assign Y3 = ~w && (y[1] || y[2] || y[4] || y[5]);

endmodule

module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Instantiate the modules for Y1 and Y3
    StateBNext stateB(.y(y), .w(w), .Y1(Y1));
    StateDNext stateD(.y(y), .w(w), .Y3(Y3));

endmodule