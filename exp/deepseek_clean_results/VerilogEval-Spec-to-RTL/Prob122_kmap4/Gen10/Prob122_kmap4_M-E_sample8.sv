module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire row_diff = a ^ c;
    wire col_diff = b ^ d;
    assign out = row_diff ^ ~col_diff;

endmodule