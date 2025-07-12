module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
// Implement the multiplexer using logical operators
assign out = (sel && b) || (!sel && a);
endmodule