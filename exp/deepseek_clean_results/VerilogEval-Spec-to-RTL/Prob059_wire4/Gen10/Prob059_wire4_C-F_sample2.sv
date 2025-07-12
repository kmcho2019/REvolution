module TopModule (
    input  a,    // Input signal a
    input  b,    // Input signal b
    input  c,    // Input signal c
    output w,    // Output w connected to a
    output x,    // Output x connected to b
    output y,    // Output y connected to b
    output z     // Output z connected to c
);
    // Single efficient assignment mapping inputs to outputs:
    // a->w, b->x, b->y, c->z
    assign {w, x, y, z} = {a, b, b, c};
endmodule