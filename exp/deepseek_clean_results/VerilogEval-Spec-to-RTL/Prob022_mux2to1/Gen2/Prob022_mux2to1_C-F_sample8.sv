// Simple 2-to-1 multiplexer
// When sel=0: out = a
// When sel=1: out = b
module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);
    assign out = sel ? b : a;
endmodule