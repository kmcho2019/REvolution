module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Given the expression is already simplified to (a) | ((b | c) & ~a), let's keep it as is
// and rely on the synthesis tool to optimize it further based on the target technology.
assign out = (a) | ((b | c) & ~a);

endmodule