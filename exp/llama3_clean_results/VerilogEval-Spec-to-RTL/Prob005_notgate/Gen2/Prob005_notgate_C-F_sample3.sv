module TopModule(
    input  in,
    output out
);
    // Assign the inverted input to the output using the logical NOT operator (~)
    assign out = ~in;
endmodule