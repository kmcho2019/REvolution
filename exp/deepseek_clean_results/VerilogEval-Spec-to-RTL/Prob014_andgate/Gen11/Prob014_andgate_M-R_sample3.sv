module TopModule(
    input a,
    input b,
    output out
);
    // Direct AND gate implementation using continuous assignment
    assign out = a & b;
endmodule