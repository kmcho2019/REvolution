module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = x & (~y); // Optimized logic
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y); // Simplified comparator logic
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a_out, b_out;
    
    ModuleA A(x, y, a_out);
    ModuleB B(x, y, b_out);
    
    assign z = a_out ^ b_out; // Direct XOR operation
endmodule