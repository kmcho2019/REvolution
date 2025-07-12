module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// From the waveform analysis:
// - z is 1 when x equals y (both 0 or both 1)
// - z is 0 otherwise
// This behavior corresponds exactly to the XNOR function.
//
// Thus, z is implemented as the bitwise XNOR of inputs x and y.

assign z = x ~^ y;

endmodule