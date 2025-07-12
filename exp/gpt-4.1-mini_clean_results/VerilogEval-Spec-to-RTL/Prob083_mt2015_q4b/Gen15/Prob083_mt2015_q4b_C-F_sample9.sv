module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    // Output z is high when inputs x and y are equal (XNOR function).
    // This matches the observed waveform where z = 1 if x == y, else 0.
    assign z = x ~^ y;

endmodule