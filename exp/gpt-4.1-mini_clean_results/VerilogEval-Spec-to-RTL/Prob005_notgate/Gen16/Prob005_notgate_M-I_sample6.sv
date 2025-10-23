module TopModule (
    input  wire in,
    output wire out
);
    // Direct continuous assignment for NOT gate, flattening hierarchy
    assign out = ~in;
endmodule