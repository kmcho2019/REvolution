module TopModule (
    input x,
    input y,
    output z
);
    // Direct gate-level implementation
    wire not_y;
    assign not_y = ~y;
    assign z = x & not_y;
endmodule