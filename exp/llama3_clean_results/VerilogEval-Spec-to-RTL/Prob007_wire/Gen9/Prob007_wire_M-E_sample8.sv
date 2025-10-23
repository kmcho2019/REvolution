module TopModule(
    input  in,
    output out
);
    
    // Using a buf gate to buffer the input
    buf buf_instance (out, in);

endmodule