module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Output z is high when inputs x and y are equal,
// implementing an XNOR function: z = x XNOR y.
// This matches the given waveform where z=1 if x=y, else z=0.
assign z = x ^~ y;

endmodule