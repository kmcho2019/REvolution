module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    assign Y1 = y[1];

    // next-state logic for y[1]
    // y[1] is 1 in the next state if we are in state A (000) and w = 1, or
    // if we are in state C (010) and w = 1, or
    // if we are in state D (011) and w = 0, or
    // if we are in state E (100) and w = 0

    // Verilog expression for next-state logic of y[1]
    assign y[1] = (y == 3'b000 && w == 1'b1) || 
                  (y == 3'b010 && w == 1'b1) || 
                  (y == 3'b011 && w == 1'b0) || 
                  (y == 3'b100 && w == 1'b0);

endmodule