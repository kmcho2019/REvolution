module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;

    // Group y[1] and y[2]
    wire y12 = y[1] | y[2];
    // Group y[4] and y[5]
    wire y45 = y[4] | y[5];
    // Combine groups for Y3
    wire y1345 = y12 | y45;

    // Next state input for y[1] (state B)
    assign Y1 = y[0] & w;

    // Next state input for y[3] (state D)
    assign Y3 = w_n & (y[3] | y1345);

    // Note: y[3] corresponds to state D itself; 
    // According to FSM transitions, no self-transition to D on w=0 from D(0) --0--> A, so including y[3] here would be incorrect.
    // Actually, the original spec only had B, C, E, F going to D on w=0. So y[3] itself should not be included in Y3.
    // Remove y[3]:

    assign Y3 = w_n & (y12 | y45); // Corrected

endmodule