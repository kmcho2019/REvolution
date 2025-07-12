module TopModule(
    input  in,
    output out
);
    
    assign out = in; // Direct assignment acts like a buffer

    // Alternatively, for educational purposes, a buf gate can be explicitly described
    // buf u_buf (out, in);

endmodule