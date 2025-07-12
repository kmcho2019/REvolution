module TopModule (
    input a,
    input b,
    output out
);
    // NOR gate implemented using continuous assignment
    assign out = ~(a | b);
endmodule