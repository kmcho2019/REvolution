module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = ~(x & ~y); // This is equivalent to z = ~x | y
endmodule

module TopLevelModule(x, y, z);
    input x, y;
    output z;
    wire z_A1, z_B1, z_A2, z_B2, or_out, and_out;
    
    ModuleA A1(x, y, z_A1);
    ModuleB B1(x, y, z_B1);
    ModuleA A2(x, y, z_A2);
    ModuleB B2(x, y, z_B2);
    
    or or_gate(z_A1, z_B1, or_out);
    and and_gate(z_A2, z_B2, and_out);
    xor xor_gate(or_out, and_out, z);
endmodule