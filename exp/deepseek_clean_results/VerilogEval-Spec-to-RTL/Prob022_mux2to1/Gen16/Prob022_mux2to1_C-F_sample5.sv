// Simple 2-to-1 multiplexer with select control
// sel=0: out = a
// sel=1: out = b
module TopModule (
    input a,
    input b,
    input sel,
    output out
);
    assign out = sel ? b : a;
endmodule