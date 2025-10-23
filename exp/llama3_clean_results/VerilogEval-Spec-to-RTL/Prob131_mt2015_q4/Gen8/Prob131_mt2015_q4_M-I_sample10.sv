module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (!x & !y);
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1, a2, b1, b2, or_out, and_out;

    ModuleA A1(x, y, a1);
    ModuleB B1(x, y, b1);
    ModuleA A2(x, y, a2);
    ModuleB B2(x, y, b2);

    assign or_out = a1 | b1;
    assign and_out = a2 & b2;
    assign z = or_out ^ and_out; // Correct implementation of the original top-level module
endmodule