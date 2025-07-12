module TopModule (
    input  wire in,
    output wire out
);
    // Direct continuous assignment implements the NOT gate efficiently
    assign out = ~in;
endmodule