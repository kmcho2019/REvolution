module TopModule (
    input a,
    input b,
    output out
);
    wire a_n, b_n;
    assign a_n = ~a;
    assign b_n = ~b;
    assign out = ~(a_n & b_n);
endmodule