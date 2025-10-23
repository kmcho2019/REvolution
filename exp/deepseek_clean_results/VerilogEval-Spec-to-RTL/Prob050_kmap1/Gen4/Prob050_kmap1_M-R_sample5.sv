module TopModule(
    input a,
    input b,
    input c,
    output out
);
    wire or_ab;
    assign or_ab = a | b;
    assign out = or_ab | c;
endmodule