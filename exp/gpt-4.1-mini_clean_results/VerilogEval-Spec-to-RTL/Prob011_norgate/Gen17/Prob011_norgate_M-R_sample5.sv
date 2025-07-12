module TopModule (
    input  a,
    input  b,
    output out
);
    // Directly assign the NOR of inputs a and b to output
    assign out = ~(a | b);
endmodule