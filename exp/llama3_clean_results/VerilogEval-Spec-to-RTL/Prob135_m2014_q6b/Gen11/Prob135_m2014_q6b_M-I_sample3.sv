module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    assign Y1 = ((y == 3'b000 && w) || 
                 (y == 3'b001 && w) || 
                 (y == 3'b010 && w) || 
                 (y == 3'b011 && w) || 
                 (y == 3'b101 && ~w) ||
                 (y == 3'b000 && ~w && ~y[1]));
endmodule