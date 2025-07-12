module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire row_pattern = (c == d) ? 1'b0 : 1'b1;
    wire col_pattern = (a == b) ? 1'b0 : 1'b1;
    
    assign out = row_pattern ^ col_pattern;

endmodule