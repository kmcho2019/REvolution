module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

// Next-state logic for y[1]
assign Y1 = (y == 3'b000 && w == 1) || 
           (y == 3'b001 && w == 1) || 
           (y == 3'b001 && w == 0) || 
           (y == 3'b010 && w == 0) || 
           (y == 3'b010 && w == 1) || 
           (y == 3'b011 && w == 1) || 
           (y == 3'b011 && w == 0) || 
           (y == 3'b101 && w == 1) || 
           (y == 3'b110 && w == 0) || 
           (y == 3'b110 && w == 1);

endmodule