module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Count the number of 1s among the inputs
    wire count;
    assign count = a + b + c + d;

    // Output 1 if the count is odd (i.e., count[0] is 1)
    assign out = count[0];

endmodule