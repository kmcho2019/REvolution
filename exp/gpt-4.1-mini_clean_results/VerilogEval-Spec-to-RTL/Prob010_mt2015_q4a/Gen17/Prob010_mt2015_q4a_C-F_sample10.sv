module TopModule (
    input  x,
    input  y,
    output z
);
    wire not_y;

    // Inverter for ~y using primitive not gate
    not (not_y, y);
    // AND gate for x & ~y using primitive and gate
    and (z, x, not_y);
endmodule