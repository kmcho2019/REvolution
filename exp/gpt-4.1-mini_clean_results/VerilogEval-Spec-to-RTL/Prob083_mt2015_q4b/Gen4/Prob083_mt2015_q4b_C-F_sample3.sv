module TopModule(
    input  wire x,
    input  wire y,
    output wire z
);
    // Output z is high when inputs x and y are equal (both 0 or both 1)
    // This corresponds exactly to the XNOR operation and matches the waveform
    assign z = x ~^ y;
endmodule