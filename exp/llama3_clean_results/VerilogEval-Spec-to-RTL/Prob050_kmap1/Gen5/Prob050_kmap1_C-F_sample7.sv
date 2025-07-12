module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Utilizing the simplified expression from the second example
// and relying on the synthesis tool to optimize it further
assign out = a | b | c;

endmodule