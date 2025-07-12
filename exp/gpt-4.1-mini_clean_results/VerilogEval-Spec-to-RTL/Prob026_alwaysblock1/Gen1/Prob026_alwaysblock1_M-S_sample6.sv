module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);

    // AND using assign statement
    assign out_assign = a & b;

    // Derive second output directly from the first to avoid redundant logic
    assign out_alwaysblock = out_assign;

endmodule