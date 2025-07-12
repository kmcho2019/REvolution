// Define a Buffer module for modularity and reusability
module Buffer(
    input  buf_in,
    output buf_out
);
    
    // Buffer implementation using continuous assignment for efficiency
    assign buf_out = buf_in;

endmodule

// Define the TopModule with the required interface
module TopModule(
    input  in,
    output out
);
    
    // Instantiate the Buffer module to maintain modularity
    Buffer buf_instance(
        .buf_in(in),
        .buf_out(out)
    );

endmodule