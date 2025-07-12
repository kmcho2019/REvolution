module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y); // Simplified logic for ModuleB
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a_out, b1_out, b2_out, or_out, and_out;
    
    assign a_out = x & (~y); // Directly compute ModuleA's logic
    assign b1_out = ~(x ^ y); // Simplified logic for ModuleB
    assign b2_out = ~(x ^ y); // Simplified logic for ModuleB
    
    assign or_out = a_out | b1_out;
    assign and_out = a_out & b2_out;
    assign z = or_out ^ and_out; // Final output logic
endmodule