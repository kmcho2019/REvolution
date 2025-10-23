module ModuleA(x, y, z);
    input x;
    input y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x;
    input y;
    output z;
    assign z = (x & y) | (!x & !y);
endmodule

module TopLevel(x, y, z);
    input x;
    input y;
    output z;
    wire a1_out, b1_out, a2_out, b2_out, or_out, and_out;

    ModuleA a1(.x(x), .y(y), .z(a1_out));
    ModuleB b1(.x(x), .y(y), .z(b1_out));
    ModuleA a2(.x(x), .y(y), .z(a2_out));
    ModuleB b2(.x(x), .y(y), .z(b2_out));

    or or_gate(.a(a1_out), .b(b1_out), .y(or_out));
    and and_gate(.a(a2_out), .b(b2_out), .y(and_out));

    xor xor_gate(.a(or_out), .b(and_out), .y(z));
endmodule