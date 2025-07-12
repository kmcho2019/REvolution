module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Single 3-input OR gate implementation
    assign out = a | b | c;
endmodule