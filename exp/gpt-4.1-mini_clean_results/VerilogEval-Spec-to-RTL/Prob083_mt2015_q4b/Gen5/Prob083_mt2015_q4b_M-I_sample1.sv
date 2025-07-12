module TopModule(
    input  wire x,
    input  wire y,
    output wire z
);
    // Output z is high when inputs x and y are equal (both 0 or both 1)
    // This matches the waveform and corresponds to the XNOR operation.
    assign z = x ~^ y;
endmodule