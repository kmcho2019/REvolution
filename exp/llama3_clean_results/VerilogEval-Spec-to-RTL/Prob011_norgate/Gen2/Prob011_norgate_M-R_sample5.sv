module TopModule(
    input a,
    input b,
    output out
);
    wire internal_nor;
    assign internal_nor = ~(a | b);
    assign out = internal_nor;
endmodule