module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // MUX-based implementation
    assign out = a ? 1'b1 : (b | c);
endmodule