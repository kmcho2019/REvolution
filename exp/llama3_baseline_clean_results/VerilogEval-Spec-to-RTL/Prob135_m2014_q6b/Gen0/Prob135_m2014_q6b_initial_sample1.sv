module TopModule (
    input  [2:0] y, // current state
    input  w,
    output Y1 // next state of y[1]
);

assign Y1 = (y == 3'b001) || (y == 3'b100) || (y == 3'b101) || (y == 3'b110) || 
            ((y == 3'b000) || (y == 3'b011)) && w;

endmodule