module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

xor u_xor (sum, a, b);
and u_and (cout, a, b);

endmodule