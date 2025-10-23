module TopModule (
    input  wire in,
    output wire out
);
    // Direct combinational assignment for NOT operation, no extra module overhead.
    assign out = ~in;
endmodule