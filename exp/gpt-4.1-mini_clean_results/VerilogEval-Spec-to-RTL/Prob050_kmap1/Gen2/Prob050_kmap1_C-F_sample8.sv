module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Direct OR for minimal and clear implementation
    assign out = a | b | c;
endmodule