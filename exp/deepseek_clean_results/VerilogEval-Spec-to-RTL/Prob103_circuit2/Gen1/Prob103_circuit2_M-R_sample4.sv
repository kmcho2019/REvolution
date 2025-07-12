module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Sum the input bits and check if the count is even (LSB = 0)
    assign q = ((a + b + c + d) & 1'b1) == 1'b0;
endmodule