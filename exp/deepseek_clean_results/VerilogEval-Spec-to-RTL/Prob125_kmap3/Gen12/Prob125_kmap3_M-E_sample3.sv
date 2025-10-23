module TopModule(
    input a,
    input b,
    input c,
    input d,  // Unused
    output out
);
    wire condition;
    assign condition = ~b & c;
    assign out = a ? 1'b1 : condition;
endmodule