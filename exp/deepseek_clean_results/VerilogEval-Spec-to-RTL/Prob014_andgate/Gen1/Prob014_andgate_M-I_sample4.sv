module TopModule(
    input a,
    input b,
    output out
);
    assign out = a & b;  // This is already the most efficient implementation
endmodule