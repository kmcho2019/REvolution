module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y);
endmodule

module ModuleC(x, y, z);
    input x, y;
    output z;
    assign z = x & y;
endmodule

module OR_Module(a, b, z);
    input a, b;
    output z;
    assign z = a | b;
endmodule

module AND_Module(a, b, z);
    input a, b;
    output z;
    assign z = a & b;
endmodule

module XOR_Module(a, b, z);
    input a, b;
    output z;
    assign z = a ^ b;
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1, b1, or_out, a2, b2, and_out;
    
    ModuleA module_a1(x, y, a1);
    ModuleB module_b1(x, y, b1);
    OR_Module or_module(a1, b1, or_out);
    
    ModuleA module_a2(x, y, a2);
    ModuleB module_b2(x, y, b2);
    AND_Module and_module(a2, b2, and_out);
    
    XOR_Module xor_module(or_out, and_out, z);
endmodule