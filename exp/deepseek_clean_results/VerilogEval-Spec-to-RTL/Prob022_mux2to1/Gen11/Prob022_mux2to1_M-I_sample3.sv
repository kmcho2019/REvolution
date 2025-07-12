module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);
    wire out = sel ? b : a;
endmodule