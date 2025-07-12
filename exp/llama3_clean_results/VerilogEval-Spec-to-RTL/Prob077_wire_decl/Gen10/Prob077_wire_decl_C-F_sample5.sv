module NOT_Gate(
    input  a,
    output out
);
    assign out = ~a;
endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    wire and_out1, and_out2;

    assign and_out1 = a & b;
    assign and_out2 = c & d;
    assign out = and_out1 | and_out2;

    NOT_Gate not_gate(
        .a(out),
        .out(out_n)
    );
endmodule