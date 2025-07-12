module TopModule (
    input  a,
    input  b,
    output out
);

    // Implement NOR directly using the NOR operator
    assign out = ~(a | b);

endmodule