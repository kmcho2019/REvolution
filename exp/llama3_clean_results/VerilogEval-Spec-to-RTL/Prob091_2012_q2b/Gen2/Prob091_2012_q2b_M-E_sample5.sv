module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Define constants for each state
parameter STATE_A = 6'b000001;
parameter STATE_B = 6'b000010;
parameter STATE_C = 6'b000100;
parameter STATE_D = 6'b001000;
parameter STATE_E = 6'b010000;
parameter STATE_F = 6'b100000;

// Assign Y1 based on the state transitions
assign Y1 = (y == STATE_A && w) || (y == STATE_F && w);

// Assign Y3 based on the state transitions
assign Y3 = (y == STATE_B && !w) || (y == STATE_C && !w) || (y == STATE_E && !w) || (y == STATE_D && !w);

endmodule