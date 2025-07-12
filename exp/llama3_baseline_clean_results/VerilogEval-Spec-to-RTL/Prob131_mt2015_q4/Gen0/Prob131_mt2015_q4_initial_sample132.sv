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

module topLevelModule(x, y, z);
    input x, y;
    output z;
    wire a1, a2, b1, b2, or_out, and_out;

    ModuleA a1_instance(x, y, a1);
    ModuleB b1_instance(x, y, b1);
    ModuleA a2_instance(x, y, a2);
    ModuleB b2_instance(x, y, b2);

    or or_instance(a1, b1, or_out);
    and and_instance(a2, b2, and_out);

    xor xor_instance(or_out, and_out, z);
endmodule