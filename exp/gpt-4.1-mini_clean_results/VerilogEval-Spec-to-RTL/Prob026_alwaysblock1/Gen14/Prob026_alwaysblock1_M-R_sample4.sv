module TopModule (
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

    wire and_result;
    assign and_result = a & b;

    assign out_assign = and_result;
    assign out_alwaysblock = and_result;

endmodule