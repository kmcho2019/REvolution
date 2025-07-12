module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// next-state logic for y[1]
assign Y1 = (y == 3'b000 && w) || 
            (y == 3'b001 && w) || 
            (y == 3'b011 && w) || 
            (y == 3'b100);

endmodule