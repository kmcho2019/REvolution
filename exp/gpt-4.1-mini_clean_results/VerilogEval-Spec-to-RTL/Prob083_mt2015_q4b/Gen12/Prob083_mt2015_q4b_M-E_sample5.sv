module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Intermediate signals representing the two conditions where z should be high
wire both_zero;
wire both_one;

// both_zero is high when both inputs are 0
assign both_zero = ~x & ~y;

// both_one is high when both inputs are 1
assign both_one = x & y;

// z is high when either both_zero or both_one is true
assign z = both_zero | both_one;

endmodule