module TopModule (
    input  wire in,
    output wire out
);
    // Direct continuous assignment for inverter function,
    // flattening hierarchy to reduce power and area overhead
    assign out = ~in;
endmodule