module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Even parity checker - output 1 when even number of inputs are 1
    assign q = (a + b + c + d) % 2 == 0;
endmodule