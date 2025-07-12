module TopModule (
    input        clk,   // clock input (unused)
    input        x,
    input  [2:0] y,     // present state
    output       Y0,
    output       z
);

    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Next state bits derived from the FSM table (simplified logic expressions)
    wire Y2 = (y == 3'b001 && x == 1'b1) | (y == 3'b100);
    wire Y1 = (y == 3'b100 && x == 1'b0) | (y == 3'b011 && x == 1'b1) | (y == 3'b010 && x == 0);
    wire Y0 = ( (y == 3'b000 && x == 1'b1) || 
                (y == 3'b011 && x == 0) || 
                (y == 3'b010 && x == 1'b0) ||
                (y == 3'b001 && x == 0) );

    // Output z is 1 only when present state y is 3'b011 or 3'b100
    assign z = (y2 & ~y1 & ~y0) | (~y2 & y1 & y0);

    assign Y0 = Y0;

endmodule