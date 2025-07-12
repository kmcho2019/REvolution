module TopModule(
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

    // Both outputs use direct continuous assignment
    assign out_assign = a & b;
    assign out_alwaysblock = a & b;

endmodule