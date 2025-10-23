module TopModule(
    input  d,
    input  ena,
    output q
);

    wire not_q;
    assign not_q = ~(q & ~ena | ~d & ena);
    assign q = ~(~q & ~ena | d & ena);

endmodule