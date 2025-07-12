module TopModule(
    input  x,
    input  y,
    output z
);
    wire xy_and;
    wire nx_ny_and;

    assign xy_and = x & y;
    assign nx_ny_and = (~x) & (~y);
    assign z = xy_and | nx_ny_and;
endmodule