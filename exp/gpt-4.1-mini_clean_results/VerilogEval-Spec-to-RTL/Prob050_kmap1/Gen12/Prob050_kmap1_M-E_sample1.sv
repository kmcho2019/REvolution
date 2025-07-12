module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire bc_or;

    assign bc_or = b | c;
    assign out = a ? 1'b1 : bc_or;
endmodule