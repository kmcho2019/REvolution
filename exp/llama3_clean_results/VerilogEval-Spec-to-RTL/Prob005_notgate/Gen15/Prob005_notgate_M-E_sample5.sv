module TopModule(
    input  in,
    output out
);

    // Using a 2-to-1 multiplexer to implement a NOT gate
    // Input 'in' is connected to both the select line and one of the inputs
    // The other input is the inverted version of 'in'
    assign out = (in == 1'b0)? ~in : in;

    // Alternatively, using a continuous assignment to implement the MUX logic
    // assign out = (in)? ~in : in; // This line is equivalent but less readable

endmodule