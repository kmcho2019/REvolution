module TopModule(
    input a,
    input b,
    output sum,
    output cout
);

    assign {cout, sum} = a + b;  // Using concatenation and addition operator

endmodule