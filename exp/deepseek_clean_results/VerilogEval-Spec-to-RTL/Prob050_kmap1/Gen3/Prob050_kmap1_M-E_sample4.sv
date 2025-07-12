module TopModule(
    input a,
    input b,
    input c,
    output out
);
    wire bc_nor;
    assign bc_nor = ~(b | c);
    assign out = a ? 1'b1 : ~bc_nor;
endmodule