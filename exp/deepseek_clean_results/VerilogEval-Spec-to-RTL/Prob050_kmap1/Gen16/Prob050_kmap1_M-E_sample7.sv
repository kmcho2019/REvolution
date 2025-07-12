module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Mux implementation where:
    // When a=1, output is 1
    // When a=0, output is b|c
    assign out = a ? 1'b1 : (b | c);
endmodule