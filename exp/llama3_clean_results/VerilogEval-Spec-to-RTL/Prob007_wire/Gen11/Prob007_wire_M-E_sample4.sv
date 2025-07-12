module Buffer(
    input  buf_in,
    output buf_out
);
    
    // Buffer implementation
    assign buf_out = buf_in;

endmodule

module TopModule(
    input  in,
    output out
);
    
    // Instantiate the buffer module
    Buffer buf_instance(
        .buf_in(in),
        .buf_out(out)
    );

endmodule