module TopModule(
    input  in,
    output out
);

    // Use a buffer gate to pass the input signal to the output
    buf u_buf(
        .a(in),
        .y(out)
    );

endmodule