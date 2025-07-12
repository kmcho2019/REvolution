module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1]
wire next_y1;
assign next_y1 = (y == 3'b100 || y == 3'b101 || y == 3'b110 || y == 3'b111) ? 1'b1 : 
                  (y == 3'b000 && w == 1'b1) ? 1'b0 : 
                  (y == 3'b001 && w == 1'b0) ? 1'b0 : 
                  (y == 3'b001 && w == 1'b1) ? 1'b0 : 
                  (y == 3'b100 && w == 1'b1) ? 1'b0 : 
                  (y == 3'b110 && w == 1'b0) ? 1'b0 : 
                  (y == 3'b111 && w == 1'b0) ? 1'b0 : 1'b0;

// Output Y1 is the current state y[1]
assign Y1 = y[1];

endmodule