module TopModule (
    input  wire in,
    output wire out
);
    // Direct continuous assignment for NOT gate
    assign out = ~in;
endmodule