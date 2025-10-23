module TopModule (
    input a,
    input b,
    output out
);
    assign out = ~(a | b);  // NOR operation implemented with continuous assignment
endmodule