// Module declaration for a NOT gate using a multiplexer
module TopModule(
    input  in,  // Input to the NOT gate
    output out   // Output of the NOT gate
);
    // Internal wire for the inverse of the input
    wire inv_in;
    
    // Generate the inverse of the input
    assign inv_in = ~in;
    
    // Use a multiplexer to select between the input and its inverse
    // The select line is tied to 1, ensuring the inverse is always selected
    assign out = (1'b1) ? inv_in : in;
endmodule