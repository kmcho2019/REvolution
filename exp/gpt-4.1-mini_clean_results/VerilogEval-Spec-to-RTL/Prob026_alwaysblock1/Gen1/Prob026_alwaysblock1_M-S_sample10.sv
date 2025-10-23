module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

    // AND using assign statement
    assign out_assign = a & b;

    // Drive out_alwaysblock directly from out_assign to avoid duplication
    assign out_alwaysblock = out_assign;

endmodule