module Buffer(
    input  buf_in,
    output buf_out
);
    
    // Buffer implementation, optimized for efficiency
    assign buf_out = buf_in;

endmodule

module TopModule(
    input  in,
    output out
);
    
    // Instantiate the optimized Buffer module for modularity and potential reusability
    Buffer buf_instance(
        .buf_in(in),
        .buf_out(out)
    );

endmodule