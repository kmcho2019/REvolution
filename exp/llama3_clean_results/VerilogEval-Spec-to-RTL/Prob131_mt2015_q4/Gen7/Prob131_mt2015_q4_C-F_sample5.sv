module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x == y);
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1_out, b1_out, a2_out, b2_out;
    
    ModuleA a1(x, y, a1_out);
    ModuleB b1(x, y, b1_out);
    ModuleA a2(x, y, a2_out);
    ModuleB b2(x, y, b2_out);
    
    // Combine the outputs using a single XOR gate
    assign z = (a1_out | b1_out) ^ (a2_out & b2_out);
endmodule