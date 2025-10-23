module TopModule (
    input  wire in,    // Input signal
    output wire out    // Inverted output
);
    // Technology-independent NOT gate implementation
    assign out = ~in;
endmodule