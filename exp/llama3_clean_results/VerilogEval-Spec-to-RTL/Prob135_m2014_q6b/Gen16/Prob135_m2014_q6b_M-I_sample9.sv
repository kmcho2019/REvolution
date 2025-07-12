module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // Directly calculate the next state of y[1] based on the current state and input w
    assign Y1 = (
        (y == 3'b000 && w == 1'b1) || 
        (y == 3'b001 && w == 1'b1) || 
        (y == 3'b010 && w == 1'b1) || 
        (y == 3'b011 && w == 1'b1) || 
        (y == 3'b100 && w == 1'b1) || 
        (y == 3'b101 && w == 1'b1)
    )? 1'b1 : 0'b0;

endmodule