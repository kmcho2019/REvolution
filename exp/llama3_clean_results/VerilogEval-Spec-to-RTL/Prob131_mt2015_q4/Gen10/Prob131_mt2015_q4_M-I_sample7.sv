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

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a_out, b_out;
    
    ModuleA a(x, y, a_out);
    ModuleB b(x, y, b_out);
    
    // Combine the outputs using a single XOR gate
    assign z = (a_out | b_out) ^ (a_out & b_out);
endmodule