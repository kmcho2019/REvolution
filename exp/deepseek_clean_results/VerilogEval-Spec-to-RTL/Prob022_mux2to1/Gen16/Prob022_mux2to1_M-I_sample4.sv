module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    // 2:1 mux implemented using ternary operator
    assign out = sel ? b : a;
endmodule