module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = x & (~y); // Optimized logic
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x == y); // Already optimized
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a_out, b_out, or_out, and_out;
    
    ModuleA A(x, y, a_out);
    ModuleB B(x, y, b_out);
    
    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;
    assign z = or_out ^ and_out; // Final output logic
endmodule