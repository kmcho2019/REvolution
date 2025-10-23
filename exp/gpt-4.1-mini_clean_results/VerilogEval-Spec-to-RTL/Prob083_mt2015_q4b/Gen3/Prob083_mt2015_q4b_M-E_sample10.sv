module TopModule(
    input x,
    input y,
    output z
);
    wire and_xy;
    wire and_nx_ny;

    assign and_xy = x & y;
    assign and_nx_ny = ~x & ~y;
    assign z = and_xy | and_nx_ny;
endmodule