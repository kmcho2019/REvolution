module TopModule (
    input  a,
    input  b,
    output out
);
    // Use continuous assignment with the reduction NOR operator to implement NOR logic
    assign out = ~(a | b);
endmodule