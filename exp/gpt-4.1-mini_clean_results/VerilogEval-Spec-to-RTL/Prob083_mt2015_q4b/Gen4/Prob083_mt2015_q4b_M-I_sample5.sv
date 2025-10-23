module TopModule (
    input wire x,
    input wire y,
    output wire z
);

// Output z is high when x equals y (XNOR function).
// This matches the specified waveform:
// z = 1 when (x,y) = (0,0) or (1,1), else 0.
//
// Using the built-in XNOR operator (~^) ensures efficient synthesis.
//
// synthesis translate_on
assign z = x ~^ y; // XNOR gate
// synthesis translate_off

endmodule