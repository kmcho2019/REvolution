module TopModule(
    input  [2:0] y,
    input  w,
    output Y1
);

// Next state logic for y[1]
// y[1] is 0 in states A, B, and C, and 1 in states D, E, and F
// Using the state machine, we can determine the next state and the value of y[1]
always @(*) begin
    if ((y == 3'b000 && w == 1) || 
        (y == 3'b001 && w == 1) || 
        (y == 3'b010 && w == 1) || 
        (y == 3'b011 && w == 0) || 
        (y == 3'b100 && w == 1) || 
        (y == 3'b101 && w == 0) || 
        (y == 3'b101 && w == 1)) begin
        Y1 = 1'b1;
    end else begin
        Y1 = 1'b0;
    end
end

endmodule