// Define the module for determining the next state of state B (y[1])
module StateBNext(
    input  [5:0] y,
    input  w,
    output reg Y1
);

    // State B (y[1]) can be reached from state A (y[0]) when w is 1
    always @(*) begin
        Y1 = w & y[0];
    end

endmodule

// Define the module for determining the next state of state D (y[3])
module StateDNext(
    input  [5:0] y,
    input  w,
    output reg Y3
);

    // Simplified logic for State D (y[3]) based on one-hot encoding
    // and the conditions under which D is reached
    always @(*) begin
        Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);
    end

endmodule

// Define the top-level module
module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Instantiate the StateBNext and StateDNext modules
    StateBNext stateB(.y(y),.w(w),.Y1(Y1));
    StateDNext stateD(.y(y),.w(w),.Y3(Y3));

endmodule