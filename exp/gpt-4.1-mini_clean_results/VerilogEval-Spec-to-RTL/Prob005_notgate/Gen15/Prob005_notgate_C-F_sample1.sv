module TopModule (
    input  wire in,
    output wire out
);
    // Continuous assignment for NOT gate: minimal area and power, and best performance
    assign out = ~in;
endmodule