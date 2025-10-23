module TopModule (
    input  wire in,
    output wire out
);
    // Direct continuous assignment implements NOT gate simply and efficiently
    assign out = ~in;
endmodule