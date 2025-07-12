module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire not_b, not_c;
    wire a_and_not_b_not_c;

    assign not_b = ~b;
    assign not_c = ~c;
    assign a_and_not_b_not_c = a & not_b & not_c;
    assign out = b | c | a_and_not_b_not_c;
endmodule