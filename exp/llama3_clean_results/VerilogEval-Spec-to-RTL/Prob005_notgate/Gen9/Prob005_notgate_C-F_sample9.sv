// Module declaration for a NOT gate
module TopModule(
    // Input signal
    input  in,
    // Output signal, which is the inverse of the input
    output out
);
    // Continuous assignment to invert the input and assign it to the output
    assign out = ~in;
endmodule