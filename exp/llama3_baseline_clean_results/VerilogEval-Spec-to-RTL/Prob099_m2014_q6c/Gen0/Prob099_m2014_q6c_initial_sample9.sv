module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Next-state signal for state B (y[1])
assign Y1 = (y[5:0] == 6'b000001 && w == 1) || 
            (y[5:0] == 6'b000100 && w == 0) || 
            (y[5:0] == 6'b001000 && w == 1) || 
            (y[5:0] == 6'b100000 && w == 1);

// Next-state signal for state D (y[3])
assign Y3 = (y[5:0] == 6'b000010 && w == 1) || 
            (y[5:0] == 6'b000100 && w == 1) || 
            (y[5:0] == 6'b001000 && w == 0) || 
            (y[5:0] == 6'b100000 && w == 1);

endmodule