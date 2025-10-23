module TopModule (
    input a,       // Unused input (required by interface)
    input b,       // Primary OR input
    input c,       // Primary OR input
    input d,       // Unused input (required by interface)
    output q       // Combinational OR output
);

    assign q = b | c;  // Core functionality

endmodule