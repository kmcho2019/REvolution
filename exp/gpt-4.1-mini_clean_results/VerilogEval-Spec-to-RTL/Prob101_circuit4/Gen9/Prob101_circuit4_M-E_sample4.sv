module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire bc_flag;
    assign bc_flag = b | c;

    assign q = bc_flag ? 1'b1 : 1'b0;

endmodule