module StateBNext(
    input  [5:0] y,
    input  w,
    output reg Y1
);

    // State B (y[1]) can be reached from state A (y[0]) when w is 1
    // Use a simple AND gate to minimize logic and reduce power consumption
    always @(*) begin
        Y1 = y[0] && w;
    end

endmodule

module StateDNext(
    input  [5:0] y,
    input  w,
    output reg Y3
);

    // State D (y[3]) can be reached from states B, C, E, and F when w is 0
    // Use a simple OR and AND combination to minimize logic and reduce power consumption
    always @(*) begin
        Y3 = ~w && (y[1] || y[2] || y[4] || y[5]);
    end

endmodule

module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Instantiate the modules for states B and D
    StateBNext stateB(.y(y),.w(w),.Y1(Y1));
    StateDNext stateD(.y(y),.w(w),.Y3(Y3));

endmodule