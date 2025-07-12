module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out // Declare 'out' as a reg
);

always @(*)
    out = (a & b) | (d & ~b) | (~a & ~b & ~c) | (~a & b & c);

endmodule