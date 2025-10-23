module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

    // Single wire for AND result
    wire and_result = a & b;

    // Assign outputs to the same AND result
    assign out_assign = and_result;
    assign out_alwaysblock = and_result;

endmodule