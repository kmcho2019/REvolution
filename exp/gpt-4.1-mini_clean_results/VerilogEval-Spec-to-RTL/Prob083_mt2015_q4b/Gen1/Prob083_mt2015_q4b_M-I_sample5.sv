module TopModule (
    input x,
    input y,
    output z
);

// Output z is high when x and y are equal (XNOR function)
// Matches waveform: z = 1 when (x,y) = (0,0) or (1,1), else 0
assign z = ~(x ^ y);

endmodule