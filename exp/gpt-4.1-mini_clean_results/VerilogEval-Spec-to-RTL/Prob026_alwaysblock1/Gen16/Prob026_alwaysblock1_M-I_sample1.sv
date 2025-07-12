module TopModule (
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

    wire and_out;
    assign and_out = a & b;

    assign out_assign = and_out;
    assign out_alwaysblock = and_out;

endmodule