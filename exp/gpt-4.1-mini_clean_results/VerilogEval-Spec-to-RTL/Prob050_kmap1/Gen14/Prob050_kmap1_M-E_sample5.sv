module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire zero_condition;

    // zero_condition is high only when a=0, b=0, c=0
    assign zero_condition = ~a & ~b & ~c;

    // out is the inverse of zero_condition
    assign out = ~zero_condition;
endmodule