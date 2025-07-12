module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Individual bits for clarity
    wire y0 = y[0];
    wire y1 = y[1];
    wire y2 = y[2];

    // Intermediate signals for clean logic and possible synthesis optimization
    wire y1_or_y2 = y1 | y2;
    wire not_y0 = ~y0;
    wire not_y1 = ~y1;

    // Next-state logic for y[1] based on FSM transition table and encoding
    wire next_y1 = (y0 & not_y1) | (not_y0 & w & y1_or_y2);

    // Output assigned to next state bit y[1]
    assign Y1 = next_y1;

endmodule