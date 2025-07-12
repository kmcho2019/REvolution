// Module declaration for a NOT gate
module TopModule(
    input  logic in,  // Input to the NOT gate
    output logic out   // Output of the NOT gate
);
    // Directly assign the inverse of the input to the output
    assign out = ~in;
endmodule