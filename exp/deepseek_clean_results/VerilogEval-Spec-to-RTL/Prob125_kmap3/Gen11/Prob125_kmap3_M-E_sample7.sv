module TopModule(
    input a,
    input b,
    input c,
    input d,  // Unused
    output out
);
    wire condition = ~b & c;
    assign out = a | condition;
endmodule