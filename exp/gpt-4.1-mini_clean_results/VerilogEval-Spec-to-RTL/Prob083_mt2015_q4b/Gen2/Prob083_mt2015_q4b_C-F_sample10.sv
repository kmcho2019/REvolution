module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Output z is high when inputs x and y are equal (XNOR function)
// This matches the given waveform:
// z = 1 when (x,y) = (0,0) or (1,1), else z = 0
assign z = ~(x ^ y);

endmodule