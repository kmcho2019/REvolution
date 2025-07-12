module MUX2 (
    input  d0,
    input  d1,
    input  s,
    output y
);
    assign y = s ? d1 : d0;
endmodule

module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    MUX2 mux_inst (
        .d0(x2),
        .d1(x1),
        .s(x3),
        .y(f)
    );
endmodule