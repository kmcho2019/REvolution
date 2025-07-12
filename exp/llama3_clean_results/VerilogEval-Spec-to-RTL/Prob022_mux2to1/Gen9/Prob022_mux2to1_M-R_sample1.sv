module TopModule(
    input  a,
    input  b,
    input  sel,
    output reg out
);
always @(*)
    out = sel ? b : a;
endmodule