module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

// Directly encode the logic for Y1 and Y3 based on the state machine transitions
always @(*) begin
    // Y1 (corresponding to y[0]) is 1 when the next state is A
    Y1 = (y[0] && !w) || (y[3] && w);
    
    // Y3 (corresponding to y[2]) is 1 when the next state is C
    Y3 = (y[1] && !w) || (y[2] && !w);
end

endmodule