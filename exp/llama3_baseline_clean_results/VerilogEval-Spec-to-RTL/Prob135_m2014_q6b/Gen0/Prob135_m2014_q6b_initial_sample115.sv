module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

wire next_y1;

assign next_y1 = (y == 3'b000 && w) || 
                 (y == 3'b001 && w) || 
                 (y == 3'b011 && w) || 
                 (y == 3'b100);

assign Y1 = next_y1;

endmodule