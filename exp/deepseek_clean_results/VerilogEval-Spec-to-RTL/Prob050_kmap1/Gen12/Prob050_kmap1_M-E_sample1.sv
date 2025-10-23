module TopModule (
    input a,
    input b,
    input c,
    output out
);
    wire bc_nand;
    assign bc_nand = ~(b & c);
    assign out = ~(a & bc_nand);
endmodule