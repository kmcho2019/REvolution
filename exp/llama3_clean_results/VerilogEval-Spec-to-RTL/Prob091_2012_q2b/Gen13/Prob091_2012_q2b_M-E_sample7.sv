module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

    // Distributed, table-driven approach
    // Create a separate module for each state flip-flop
    wire y1_next;
    wire y3_next;

    // Module for y[1]
    assign y1_next = (y[0] & w);

    // Module for y[3]
    assign y3_next = (~w & (y[1] | y[2] | y[4] | y[5]));

    // Assign the next-state values for Y1 and Y3
    assign Y1 = y1_next;
    assign Y3 = y3_next;

endmodule