module TopModule (
    input  wire in,
    output wire out
);
    // Direct continuous assignment for NOT gate, flattened design
    assign out = ~in;
endmodule