module TopModule(
    input  in,
    output out
);
    // Directly assign the inverse of the input to the output
    assign out = ~in;
endmodule