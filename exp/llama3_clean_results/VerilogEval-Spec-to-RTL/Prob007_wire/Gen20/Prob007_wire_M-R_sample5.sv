// Define the TopModule with the required interface
module TopModule(
    input  in,
    output out
);
    
    // Directly assign the input to the output for wire-like behavior
    assign out = in;

endmodule