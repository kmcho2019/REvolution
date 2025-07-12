module TopModule(
    input  in,
    output out
);
    // Directly assign the inverse of the input to the output for a NOT gate operation
    assign out = ~in;
endmodule