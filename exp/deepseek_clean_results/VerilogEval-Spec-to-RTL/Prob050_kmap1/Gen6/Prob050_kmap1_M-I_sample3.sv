module TopModule(
    input a,
    input b,
    input c,
    output out
);
    // Output is 1 if any input is 1 (matches K-map)
    assign out = a | b | c;
endmodule