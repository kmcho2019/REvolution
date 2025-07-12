module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1]
    // This will be used to drive the D input of the flip-flop that generates y[1]
    wire next_y1;
    assign next_y1 = (y == 3'b000 && w == 1) || 
                     (y == 3'b001 && w == 1) || 
                     (y == 3'b100 || y == 3'b110) && w == 1 || 
                     (y == 3'b101);

endmodule