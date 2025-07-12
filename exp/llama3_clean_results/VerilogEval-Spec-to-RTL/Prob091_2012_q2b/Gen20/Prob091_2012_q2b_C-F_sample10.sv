module StateBNext(
    input  [5:0] y,
    input  w,
    output reg Y1
);
    // Direct assignment for simplicity and efficiency
    assign Y1 = w & y[0];
endmodule

module StateDNext(
    input  [5:0] y,
    input  w,
    output reg Y3
);
    // Simplified logic for State D (y[3]) based on one-hot encoding
    // and the conditions under which D is reached
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);
endmodule

module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);
    // Instantiate the StateBNext and StateDNext modules
    StateBNext stateB(.y(y), .w(w), .Y1(Y1));
    StateDNext stateD(.y(y), .w(w), .Y3(Y3));
endmodule