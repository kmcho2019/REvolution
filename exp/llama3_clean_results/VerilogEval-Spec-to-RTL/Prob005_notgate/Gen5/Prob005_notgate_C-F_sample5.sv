module TopModule(
    input  in,
    output out
);
    // Directly assign the inverse of the input to the output
    // This method is chosen for its simplicity and efficiency
    assign out = ~in;
endmodule