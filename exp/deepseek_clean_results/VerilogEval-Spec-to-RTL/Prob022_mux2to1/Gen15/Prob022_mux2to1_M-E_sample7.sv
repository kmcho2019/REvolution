module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // 2:1 mux implemented using bitwise operations
    assign out = (a & ~sel) | (b & sel);
endmodule