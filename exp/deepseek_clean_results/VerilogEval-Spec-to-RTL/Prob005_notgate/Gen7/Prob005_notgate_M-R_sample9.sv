module TopModule (
    input in,
    output out
);
    // Explicit wire declaration and separate assignment
    wire not_out;
    assign not_out = ~in;
    assign out = not_out;
endmodule