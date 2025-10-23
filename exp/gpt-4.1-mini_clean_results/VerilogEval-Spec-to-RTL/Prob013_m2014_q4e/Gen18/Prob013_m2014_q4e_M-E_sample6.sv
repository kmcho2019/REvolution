module TopModule (
    input  in1,
    input  in2,
    output out
);

    wire or_out;

    // Structural definition: OR gate driving inverter
    or u_or (
        .a(in1),
        .b(in2),
        .y(or_out)
    );

    not u_not (
        .a(or_out),
        .y(out)
    );

endmodule