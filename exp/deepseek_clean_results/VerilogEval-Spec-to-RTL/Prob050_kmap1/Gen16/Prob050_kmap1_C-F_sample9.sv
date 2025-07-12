module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Output is 1 unless all inputs are 0 (3-input OR)
    assign out = a | b | c;
endmodule