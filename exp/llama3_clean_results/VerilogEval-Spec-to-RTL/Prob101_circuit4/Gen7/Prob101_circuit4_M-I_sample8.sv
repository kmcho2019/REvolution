module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// The output q is 1 whenever b or c is 1, regardless of the values of a and d
// This is the most straightforward and efficient way to express this logic in Verilog
assign q = b | c;

endmodule