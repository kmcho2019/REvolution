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

    // Derived boolean function for Module B based on the simulation waveform
    assign z = ~x & ~y | x & y;
endmodule

module TopLevel(x, y, z);
    input x;
    input y;
    output z;

    wire a1, a2, b1, b2, or_out, and_out;

    ModuleA a1_inst(x, y, a1);
    ModuleB b1_inst(x, y, b1);
    ModuleA a2_inst(x, y, a2);
    ModuleB b2_inst(x, y, b2);

    or or1(a1, b1, or_out);
    and and1(a2, b2, and_out);
    xor xor1(or_out, and_out, z);
endmodule