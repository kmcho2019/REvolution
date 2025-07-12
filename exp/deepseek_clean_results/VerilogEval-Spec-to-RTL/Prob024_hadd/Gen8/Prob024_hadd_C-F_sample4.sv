module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    assign {cout, sum} = a + b;  // Concise implementation using addition operation

endmodule