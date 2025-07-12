module TopModule (
    input  wire in,
    output wire out
);
    // Continuous assignment implements inversion directly
    assign out = ~in;
endmodule