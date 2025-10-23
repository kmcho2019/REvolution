// Refactored module declaration for a NOT gate
module TopModule(
    input  in,  // Input to the NOT gate
    output out  // Output of the NOT gate
);
    // Directly assign the inverted input to the output
    assign out = ~in;
endmodule