module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = x & (x ^ y);
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (!x &!y);
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b, or_out, and_out;

    ModuleA A(x, y, a);
    ModuleB B(x, y, b);

    assign or_out = a | b;
    assign and_out = a & b;
    assign z = or_out ^ and_out;
endmodule