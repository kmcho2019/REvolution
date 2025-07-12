module NOT1 (
    input  a,
    output y
);
    assign y = ~a;
endmodule

module AND2 (
    input  a,
    input  b,
    output y
);
    assign y = a & b;
endmodule

module TopModule (
    input  x,
    input  y,
    output z
);
    wire not_y;

    NOT1 u_not (
        .a(y),
        .y(not_y)
    );

    AND2 u_and (
        .a(x),
        .b(not_y),
        .y(z)
    );
endmodule