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

module StateDNext(
    input  [5:0] y,
    input  w,
    output reg Y3
);

    // State D (y[3]) can be reached from states B, C, E, and F when w is 0
    // Simplified logic using a single gate
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

    // Instantiating the modules for state B and D next state logic
    StateBNext stateB(.y(y),.w(w),.Y1(Y1));
    StateDNext stateD(.y(y),.w(w),.Y3(Y3));

    // Applying clock gating technique
    reg clk_enable;
    always @(*) begin
        clk_enable = y[0] | y[1] | y[2] | y[4] | y[5];
    end

    // Note: The clock gating logic may vary depending on the target technology and synthesis tool

endmodule