module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is the next state for y[1] (state B) - only from A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Y3 is the next state for y[3] (state D) - from B,C,E,F when w=0
    // Since only one y bit is active, we can OR the relevant bits first
    wire states_that_lead_to_D;
    assign states_that_lead_to_D = y[1] | y[2] | y[4] | y[5];
    assign Y3 = states_that_lead_to_D & ~w;

endmodule