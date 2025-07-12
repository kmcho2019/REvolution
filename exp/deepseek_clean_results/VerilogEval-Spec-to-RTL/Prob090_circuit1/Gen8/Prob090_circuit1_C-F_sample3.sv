module TopModule (
    input a,
    input b,
    output q
);
    // Direct AND implementation for optimal PPA
    assign q = a & b;
endmodule