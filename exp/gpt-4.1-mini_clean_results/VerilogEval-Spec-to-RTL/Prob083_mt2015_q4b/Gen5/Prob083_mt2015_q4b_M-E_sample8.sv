module TopModule (
    input x,
    input y,
    output z
);

wire both_zero;
wire both_one;

// both_zero is high if x=0 and y=0
assign both_zero = ~x & ~y;

// both_one is high if x=1 and y=1
assign both_one = x & y;

// z is high if both_zero or both_one is high
assign z = both_zero | both_one;

endmodule