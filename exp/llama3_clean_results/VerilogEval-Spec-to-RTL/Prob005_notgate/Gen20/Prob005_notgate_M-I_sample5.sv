// Module declaration for a NOT gate using the logical NOT operator
module TopModule(
    input  logic in,  // Input to the NOT gate
    output logic out  // Output of the NOT gate
);
    // Use the logical NOT operator to invert the input
    assign out = ~in;
endmodule