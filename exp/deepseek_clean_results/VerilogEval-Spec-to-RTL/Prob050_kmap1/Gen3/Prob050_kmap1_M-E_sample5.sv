module TopModule(
    input a,
    input b,
    input c,
    output out
);
    wire nand_out;
    assign nand_out = ~( (~a) & (~b) & (~c) );
    assign out = nand_out;
endmodule