module TopModule(
    input a,
    input b,
    output out
);
    // CMOS-style NOR implementation
    wire nor_internal;
    assign nor_internal = a | b;
    assign out = ~nor_internal;
endmodule