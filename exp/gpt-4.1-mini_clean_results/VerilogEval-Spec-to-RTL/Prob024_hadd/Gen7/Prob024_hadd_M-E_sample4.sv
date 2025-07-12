module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

xor U1 (sum, a, b);
and U2 (cout, a, b);

endmodule