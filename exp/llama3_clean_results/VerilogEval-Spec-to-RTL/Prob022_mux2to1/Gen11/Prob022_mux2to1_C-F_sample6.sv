module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
// Implement a 2-to-1 multiplexer using the ternary operator for conciseness and efficiency.
// When sel = 0, select input a; when sel = 1, select input b.
assign out = sel? b : a;
endmodule