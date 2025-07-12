module TopModule (
    input  wire in,
    output wire out
);
    // Direct continuous assignment implementing NOT gate
    assign out = ~in;
endmodule