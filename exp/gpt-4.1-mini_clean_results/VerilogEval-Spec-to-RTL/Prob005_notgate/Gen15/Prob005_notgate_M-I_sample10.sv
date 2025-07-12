module TopModule (
    input  wire in,
    output wire out
);
    // Direct continuous assignment to implement NOT gate with minimal overhead
    assign out = ~in;
endmodule