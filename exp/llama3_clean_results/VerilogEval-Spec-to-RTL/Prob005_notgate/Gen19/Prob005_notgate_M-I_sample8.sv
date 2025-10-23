// Module declaration for a NOT gate using the logical NOT operator
module TopModule(
    input  in,  // Input to the NOT gate
    output out   // Output of the NOT gate
);
    // Use the logical NOT operator to invert the input
    assign out = ~in;
endmodule