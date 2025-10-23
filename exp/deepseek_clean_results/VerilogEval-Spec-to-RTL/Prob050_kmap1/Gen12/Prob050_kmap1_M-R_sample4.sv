module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Implement 3-input OR using continuous assignment
    assign out = a | b | c;
endmodule