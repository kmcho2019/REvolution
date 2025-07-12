module TopModule(
    input  in,
    output out
);
    // Direct implementation of a NOT gate using the bitwise NOT operator
    assign out = ~in;
endmodule