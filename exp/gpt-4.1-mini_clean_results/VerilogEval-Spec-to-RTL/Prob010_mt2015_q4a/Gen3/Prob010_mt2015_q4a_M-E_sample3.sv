module TopModule(
    input x,
    input y,
    output z
);
    wire not_x, not_y;
    wire and1, and2;
    wire xor_out;

    assign not_x = ~x;
    assign not_y = ~y;

    assign and1 = x & not_y;
    assign and2 = not_x & y;

    assign xor_out = and1 | and2;

    assign z = xor_out & x;
endmodule