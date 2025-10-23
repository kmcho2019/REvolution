module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    assign Y1 = y[1];

    // Next state logic for y[1]
    wire next_y1;
    assign next_y1 = (y == 3'b000 && w) ? 1'b0 : 
                     (y == 3'b001 && w) ? 1'b1 : 
                     (y == 3'b001 && ~w) ? 1'b0 : 
                     (y == 3'b010 && w) ? 1'b1 : 
                     (y == 3'b010 && ~w) ? 1'b0 : 
                     (y == 3'b011 && w) ? 1'b0 : 
                     (y == 3'b011 && ~w) ? 1'b1 : 
                     (y == 3'b100 && w) ? 1'b1 : 
                     (y == 3'b100 && ~w) ? 1'b0 : 
                     (y == 3'b101 && w) ? 1'b1 : 
                     1'b0;

    // Note: The actual next state logic should be connected to y[1] in the 
    // next clock cycle, but since we are only implementing the next-state logic 
    // for y[1], we are not using next_y1 anywhere in this module.
endmodule