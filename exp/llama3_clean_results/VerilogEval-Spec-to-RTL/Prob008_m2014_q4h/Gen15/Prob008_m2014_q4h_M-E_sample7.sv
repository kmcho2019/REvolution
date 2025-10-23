module TopModule(
    input  in,
    output out
);
    buf u_buf(
        .A(in),
        .Y(out)
    );
endmodule