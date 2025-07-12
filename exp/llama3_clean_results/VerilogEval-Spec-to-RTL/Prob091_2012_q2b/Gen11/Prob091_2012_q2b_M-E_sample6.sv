module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Directly compute Y1 (next state bit for state B) based on the current state and w
    assign Y1 = (y[0] && w); // State B can be reached from A when w is 1

    // Compute Y3 (next state bit for state D) based on the current state and w
    // State D can be reached from B, C, E, F when w is 0
    assign Y3 = (~w && (y[1] || y[2] || y[4] || y[5]));

endmodule