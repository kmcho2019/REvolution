module StateBNext(
    input  [5:0] y,
    input  w,
    output reg Y1
);

    // State B (y[1]) can be reached from state A (y[0]) when w is 1
    // This logic is already minimal and directly implements the required transition.
    always @(*) begin
        Y1 = w & y[0];
    end

endmodule

module StateDNext(
    input  [5:0] y,
    input  w,
    output reg Y3
);

    // State D (y[3]) can be reached from states B, C, E, and F when w is 0
    // We use a single always block to ensure the synthesis tool can optimize the logic.
    always @(*) begin
        Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);
    end

endmodule

module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Instantiate the modules for state B and D next state logic
    StateBNext stateB(.y(y), .w(w), .Y1(Y1));
    StateDNext stateD(.y(y), .w(w), .Y3(Y3));

endmodule