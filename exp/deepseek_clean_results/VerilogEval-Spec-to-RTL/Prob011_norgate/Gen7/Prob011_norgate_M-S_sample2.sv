module TopModule (
    input a,
    input b,
    output out
);
    assign out = ~(a | b);  // NOR operation using continuous assignment
endmodule