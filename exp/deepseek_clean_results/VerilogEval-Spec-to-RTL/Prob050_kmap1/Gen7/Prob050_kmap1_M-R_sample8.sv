module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Behavioral implementation with single continuous assignment
    assign out = a | b | c;
endmodule