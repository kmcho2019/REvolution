/*
 * TopModule - 1-bit NOR Gate
 * out = ~(a | b)
 */
module TopModule (
    input  a,
    input  b,
    output out
);
    assign out = ~(a | b);
endmodule