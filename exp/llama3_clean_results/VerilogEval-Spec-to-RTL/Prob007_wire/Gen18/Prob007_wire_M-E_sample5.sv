module BufferGate(
    input  buf_in,
    output buf_out
);

    // Buffer gate implementation
    assign buf_out = buf_in;

endmodule

module TopModule(
    input  in,
    output out
);

    // Instantiate the BufferGate module
    BufferGate buf_instance(
        .buf_in(in),
        .buf_out(out)
    );

endmodule