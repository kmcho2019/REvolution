module TopModule (
    input a,
    input b,
    output q
);
    // Direct AND gate implementation for optimal PPA
    assign q = a & b;
endmodule