module TopModule (
    input in,
    output out
);
    // Direct implementation of NOT gate using bitwise negation
    assign out = ~in;
endmodule