module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

wire both_zero = ~x & ~y;
wire both_one  = x & y;

assign z = both_zero | both_one;

endmodule