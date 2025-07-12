module TopModule(
    input  in,
    output out
);
    // Directly assign the inverted input to the output
    assign out = ~in;
endmodule