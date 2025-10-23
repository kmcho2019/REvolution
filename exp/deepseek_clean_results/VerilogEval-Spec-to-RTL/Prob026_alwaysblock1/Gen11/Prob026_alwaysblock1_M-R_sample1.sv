module TopModule (
    input a,
    input b,
    output out_assign,
    output out_alwaysblock
);
    // Both outputs implemented with continuous assignments
    assign out_assign = a & b;
    assign out_alwaysblock = a & b;
endmodule