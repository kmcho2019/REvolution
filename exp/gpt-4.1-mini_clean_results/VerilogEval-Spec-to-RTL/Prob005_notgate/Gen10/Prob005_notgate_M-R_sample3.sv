module TopModule (
    input  wire in,
    output wire out
);
    // Direct continuous assignment implementing a NOT gate
    assign out = ~in;
endmodule