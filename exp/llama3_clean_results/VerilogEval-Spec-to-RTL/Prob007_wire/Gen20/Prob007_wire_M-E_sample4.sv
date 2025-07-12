module BufferModule(
    input  buf_in,
    output buf_out
);

    // Buffer implementation for direct signal passing
    assign buf_out = buf_in;

endmodule

module TopModule(
    input  in,
    output out
);

    // Instantiate the BufferModule for direct signal connection
    BufferModule buf_instance(
       .buf_in(in),
       .buf_out(out)
    );

endmodule